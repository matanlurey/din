// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: comment_references
import 'dart:async';

import 'package:din/din.dart';

import '../schema/structures/gateway.dart';
import 'ws_client.dart';

/// Defines a function that connects to a gateway [url].
typedef GatewayClientFactory = Future<GatewayClient> Function(
  WebSocketFactory factory,
  String url,
  RestClient rest,
);

/// A higher-level abstraction on top of [WebSocketClient].
///
/// The REST client does not have any specific knowledge of Discord endpoints.
class GatewayClient {
  /// Connects to a web socket [factory] to [url].
  static Future<GatewayClient> connect(
    WebSocketFactory factory,
    String url,
    RestClient rest,
  ) async {
    final client = await factory(url, headers: rest.getHttpHeaders());
    return new GatewayClient._(client);
  }

  final WebSocketClient _client;
  final _onHello = new Completer<String>();

  Stream<GatewayDispatch> _stream;
  Timer _heartBeat;

  GatewayClient._(this._client) {
    _stream = _client.onMessage.map((message) {
      final dispatch = new GatewayDispatch.fromJson(message);
      switch (dispatch.op) {
        case GatewayOpcode.hello:
          final hello = dispatch.data as Map<String, Object>;
          _heartBeat = new Timer.periodic(
            new Duration(milliseconds: hello['heartbeat_interval'] as int),
            _onHeartBeat,
          );
          _onHello.complete(hello['_trace'] as String);
          return null;
        default:
          return dispatch;
      }
    }).where((d) => d != null);
  }

  void _onHeartBeat(Timer _) {
    // TODO: Await ack.
  }

  /// Closes the gateway client.
  Future<Null> close() async {
    _heartBeat?.cancel();
    _client.close();
  }

  /// A stream of JSON decoded messages.
  Stream<GatewayDispatch> get onMessage => _stream;

  /// Completes on the initial "hello" message with debug information.
  Future<String> get onHello => _onHello.future;
}
