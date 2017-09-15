// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:din/din.dart' as din;

/// Implements [HttpClient] for both the standalone Dart VM and Flutter.
class VmHttpClient implements din.HttpClient {
  static HttpClient _defaultHttpClient() => new HttpClient();

  final HttpClient Function() _createHttpClient;

  const VmHttpClient([this._createHttpClient = _defaultHttpClient]);

  @override
  CancelableOperation< /*Json*/ Object> requestJson(
    String path, {
    String method: 'GET',
    Map<String, Object> payload,
    Map<String, String> headers: const {},
  }) {
    final client = _createHttpClient();
    var isCancelled = false;
    void Function() onCancel;
    final completer = new CancelableCompleter< /*Json*/ Object>(
      onCancel: () {
        isCancelled = true;
        if (onCancel != null) {
          onCancel();
        }
      },
    );
    client.openUrl(method, Uri.parse(path)).then((request) {
      onCancel = () {
        request.close();
      };
      if (isCancelled) {
        onCancel();
        return;
      }
      headers.forEach(request.headers.set);
      if (payload != null) {
        request.headers.contentType = ContentType.JSON;
        request.write(JSON.encode(payload));
      }
      request.close();
      request.done.then((response) async {
        // TODO: Make this more robust, and throw an HttpException.
        if (response.statusCode >= 400) {
          completer.completeError(new din.HttpClientException(
            response.statusCode,
            response.reasonPhrase,
          ));
          return;
        }
        completer.complete(JSON.decode(await UTF8.decodeStream(response)));
        client.close();
      }, onError: (Object error) {
        completer.completeError(new din.HttpClientException.from(error));
      });
    });
    return completer.operation;
  }
}

/// Implements [WebSocketClient] for both the standalone Dart VM and Flutter.
class VmWebSocketClient implements din.WebSocketClient {
  static Future<VmWebSocketClient> connect(
    String url, {
    Map<String, String> headers: const {},
  }) async {
    final socket = await WebSocket.connect(url, headers: headers);
    return new VmWebSocketClient._(socket);
  }

  final WebSocket _socket;

  const VmWebSocketClient._(this._socket);

  @override
  void addJson(Object json) {
    _socket.add(JSON.encode(json));
  }

  @override
  Future<Null> close() async {
    await _socket.close();
  }

  @override
  Stream<Map<String, Object>> get onMessage {
    return _socket.map(
      (dynamic m) => JSON.decode(m as String) as Map<String, Object>,
    );
  }

  @override
  Future<String> get onClose => _socket.done.then((Object reason) {
        if (reason is WebSocket) {
          return null;
        }
        if (reason != null) {
          return reason.toString();
        }
        return _socket.closeReason;
      });
}
