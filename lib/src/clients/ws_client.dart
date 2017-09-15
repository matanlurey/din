// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: comment_references
import 'dart:async';

/// Defines a function that connects to a web socket [url].
typedef WebSocketFactory = Future<WebSocketClient> Function(
  String url, {
  Map<String, String> headers,
});

/// Defines the web socket interface necessary for the gateway client.
///
/// This allows different client implementations on different platforms to
/// provide their own implementation of web socket, without relying on `din` to
/// keep one updated.
///
/// Default implementations are available; see `package:din/platform/*.dart`.
abstract class WebSocketClient {
  /// Sends JSON data on the web socket, encoded automatically as a UTF8 string.
  void addJson(/*Json*/ Object json);

  /// Closes the web socket.
  Future<Null> close();

  /// Stream of JSON messages.
  Stream<Map<String, Object>> get onMessage;
}
