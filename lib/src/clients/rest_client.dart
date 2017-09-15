// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:din/platform/vm.dart';
import 'package:meta/meta.dart';

import '../auth_scheme.dart';
import '../user_agent.dart';
import 'http_client.dart';

/// A higher-level abstraction on top of [HttpClient] for making REST calls.
///
/// The REST client does not have any specific knowledge of Discord endpoints.
class RestClient {
  static const _defaultBaseUrl = 'https://discordapp.com/api';
  static const _recommendedApiVersion = 6;

  // ignore: unused_field
  final AuthScheme _authScheme;

  // ignore: unused_field
  final String _baseUrl;

  // ignore: unused_field
  final HttpClient _http;

  // ignore: unused_field
  final UserAgent _userAgent;

  /// Create a new REST client to access the Discord API.
  ///
  /// May optionally specify an [api version](https://discordapp.com/developers/docs/reference)
  /// which in turn is used to connect to a specific version of the Discord API.
  ///
  /// On platforms other than the standalone VM or Flutter (i.e. on the web) it
  /// is required to pass in a different implementation of [http], otherwise an
  /// [UnsupportedError] is thrown at runtime.
  const RestClient({
    int apiVersion: _recommendedApiVersion,
    @required AuthScheme auth,
    HttpClient http: const VmHttpClient(),
    UserAgent userAgent: UserAgent.defaultDin,
  })
      : this.withBaseUrl(
          apiVersion == null
              ? _defaultBaseUrl
              : '$_defaultBaseUrl/v$apiVersion',
          auth: auth,
          http: http,
          userAgent: userAgent,
        );

  /// Creates a new REST client with a specific base API url.
  ///
  /// Useful for scenarios for testing (i.e. mock server), for proxies, or for
  /// alternative API servers (early access, third party, etc).
  ///
  /// On platforms other than the standalone VM or Flutter (i.e. on the web) it
  /// is required to pass in a different implementation of [http], otherwise an
  /// [UnsupportedError] is thrown at runtime.
  const RestClient.withBaseUrl(
    this._baseUrl, {
    @required AuthScheme auth,
    HttpClient http: const VmHttpClient(),
    UserAgent userAgent: UserAgent.defaultDin,
  })
      : _authScheme = auth,
        _http = http,
        _userAgent = userAgent;

  /// Returns HTTP headers required by all REST invocations.
  ///
  /// Sub-classes _may_ override to add or modify the headers added.
  @protected
  Map<String, String> getHttpHeaders() {
    return {
      'Authorization': _authScheme.headerValue,
      'User-Agent': _userAgent.headerValue,
    };
  }

  /// Make an authenticated HTTP request against a REST endpoint.
  Future< /*Json*/ Object> request({
    @required String method,
    @required String url,
    Map<String, String> query: const {},
    Map<String, Object> json,
  }) =>
      _http
          .requestJson(
            '$_baseUrl/$url',
            method: method,
            payload: json,
            headers: getHttpHeaders(),
          )
          .value;
}
