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
    final client = await factory(url);
    return new GatewayClient._(client, rest);
  }

  final RestClient _rest;
  final WebSocketClient _client;

  final _onHello = new Completer<List<String>>();
  final _onMessage = new StreamController<GatewayDispatch>.broadcast();
  final _onReady = new Completer<Object>();

  Timer _heartBeat;

  GatewayClient._(this._client, this._rest) {
    _client.onMessage.listen((message) {
      final dispatch = new GatewayDispatch.fromJson(message);
      switch (dispatch.op) {
        case GatewayOpcode.hello:
          final hello = dispatch.data as Map<String, Object>;
          _heartBeat = new Timer.periodic(
            new Duration(milliseconds: hello['heartbeat_interval'] as int),
            _onHeartBeat,
          );
          _client.addJson({
            'op': GatewayOpcode.identify.index,
            'd': {
              'token': '${_rest.auth.token}',
              'properties': {
                '\$browser': 'disco',
              },
              'compress': false,
              'large_threshold': 50,
              'shard': [0, 1],
              'presence': {
                'status': 'online',
                'afk': false,
              }
            }
          });
          _onHello.complete(hello['_trace'] as List<String>);
          break;
        case GatewayOpcode.dispatch:
          switch (dispatch.name) {
            case 'READY':
              _onReady.complete(dispatch.data);
              break;
          }
          break;
        default:
          _onMessage.add(dispatch);
      }
    }, onDone: () {
      // TODO: Better error handling.
      close();
    });
  }

  void _onHeartBeat(Timer _) {
    // TODO: Await ack.
  }

  /// Closes the gateway client.
  Future<Null> close() async {
    _onMessage.close();
    _heartBeat?.cancel();
    _client.close();
  }

  /// A stream of JSON decoded messages.
  Stream<GatewayDispatch> get onMessage => _onMessage.stream;

  /// Completes on the initial "hello" message with debug information.
  Future<List<String>> get onHello => _onHello.future;

  /// Completes on authentication success.
  Future<Object> get onReady => _onReady.future;
}
