// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:async/async.dart';

/// Defines the HTTP interface necessary for the REST client.
///
/// This allows different client implementations on different platforms to
/// provide their own implementation of HTTP, without relying on `din` to keep
/// one updated.
///
/// Default implementations are available; see `package:din/platform/*.dart`.
abstract class HttpClient {
  /// Sends an HTTP request to [path] using [method].
  ///
  /// May optionally define a [payload] and HTTP [headers].
  ///
  /// Unlike a standard [Future], a [CancelableOperation] may be cancelled if
  /// the in-flight request is no longer valid or wanted. In that event, the
  /// [CancelableOperation.value] may never complete.
  ///
  /// May throw a [HttpClientException] if the request fails.
  CancelableOperation< /*Json*/ Object> requestJson(
    String path, {
    String method: 'GET',
    Map<String, Object> payload,
    Map<String, String> headers,
  });
}

/// Thrown by [HttpClient] when an HTTP or network error occurs.
class HttpClientException implements Exception {
  final int code;
  final String reason;

  /// An HTTP exception with an error [code] and optional [reason].
  const HttpClientException(this.code, [this.reason]);

  /// An HTTP exception caused by another [error].
  const factory HttpClientException.from(
    Object error,
  ) = _WrappedHttpClientException;

  /// An HTTP exception caused by unknown causes.
  const HttpClientException.unknown() : this(null, null);

  @override
  String toString() {
    if (code == null) {
      return 'Unknown';
    }
    if (reason == null) {
      return '$code';
    }
    return '$code: $reason';
  }
}

class _WrappedHttpClientException extends HttpClientException {
  final Object _error;

  const _WrappedHttpClientException(this._error) : super(null, null);

  @override
  String toString() => _error.toString();
}
