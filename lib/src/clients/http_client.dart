// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:async/async.dart';

/// Defines the HTTP interface necessary for the API client.
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
  CancelableOperation<Map<String, Object>> requestJson(
    String path, {
    String method: 'GET',
    Map<String, Object> payload,
    Map<String, String> headers,
  });
}
