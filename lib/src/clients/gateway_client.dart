// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: comment_references
import 'dart:async';

import 'package:din/din.dart';

import '../schema/structures/gateway.dart';
import 'gateway_events.dart';
import 'ws_client.dart';

/// Defines a function that connects to a gateway [url].
typedef GatewayClientFactory = Future<GatewayClient> Function(
  WebSocketFactory factory,
  String url,
  RestClient rest, {
  OnGatewayIdentify onIdentify,
});

/// Invoked on initial identification to the gateway server.
typedef OnGatewayIdentify = GatewayIdentify Function(
  GatewayIdentifyStrategy strategy,
);

/// A higher-level abstraction on top of [WebSocketClient].
///
/// The REST client does not have any specific knowledge of Discord endpoints.
class GatewayClient {
  static GatewayIdentify _defaultIdentify(GatewayIdentifyStrategy strategy) {
    return strategy.asBrowser('Unknown');
  }

  /// Connects to a web socket [factory] to [url].
  static Future<GatewayClient> connect(
    WebSocketFactory factory,
    String url,
    RestClient rest, {
    OnGatewayIdentify onIdentify,
  }) async {
    onIdentify ??= _defaultIdentify;
    final client = await factory(url);
    return new GatewayClient._(client, rest, onIdentify: onIdentify);
  }

  final RestClient _rest;
  final WebSocketClient _client;

  final GatewayIdentify Function(GatewayIdentifyStrategy strategy) _identify;
  final _onHello = new Completer<List<String>>();
  final _onSequenceUpdate = new StreamController<int>.broadcast();

  GatewayEvents get events => _events;
  GatewayEvents _events;
  Timer _heartBeat;
  int _lastSequence;

  GatewayClient._(
    this._client,
    this._rest, {
    GatewayIdentify Function(GatewayIdentifyStrategy strategy) onIdentify,
  })
      : _identify = onIdentify {
    final events = new StreamController<GatewayDispatch>(sync: true);
    _events = new GatewayEvents(events.stream, _onSequenceUpdate);
    _client.onMessage.listen((message) {
      final dispatch = new GatewayDispatch.fromJson(message);
      switch (dispatch.op) {
        case GatewayOpcode.hello:
          final hello = dispatch.data as Map<String, Object>;
          _heartBeat = new Timer.periodic(
            new Duration(milliseconds: hello['heartbeat_interval'] as int),
            _onHeartBeat,
          );
          _sendIdentity();
          _onHello.complete(hello['_trace'] as List<String>);
          break;
        case GatewayOpcode.dispatch:
          events.add(dispatch);
          break;
        default:
        // print('Unhandled message: $message');
      }
    }, onDone: () {
      // TODO: Better error handling.
      close();
    });
  }

  void _sendIdentity() {
    final identity = _identify(const GatewayIdentifyStrategy._()).asJson();
    _client.addJson({
      'op': GatewayOpcode.identify.index,
      'd': <String, Object>{
        'token': _rest.auth.token,
      }..addAll(identity),
    });
  }

  void _onHeartBeat(Timer _) {
    // TODO: Await ack.
    _client.addJson({
      'op': GatewayOpcode.heartbeat.index,
      'd': _lastSequence,
    });
  }

  /// Closes the gateway client.
  Future<Null> close() async {
    _heartBeat?.cancel();
    _client.close();
  }

  /// Completes when the socket closes.
  ///
  /// Returns a string from the socket describing the exception, or `null` if
  /// the reason is unknown or user-initiated (i.e. the [close] method used).
  Future<String> get onClose => _client.onClose; // TODO: Use types not string.

  /// Completes on the initial "hello" message with debug information.
  Future<List<String>> get onHello => _onHello.future;

  /// A stream of sequence number updates.
  ///
  /// Used to initiate a _resume_ action (not yet supported) and heartbeats.
  Stream<int> get onSequenceUpdate => _onSequenceUpdate.stream;
}

/// Strategies for determining a [GatewayIdentify] message on connection.
class GatewayIdentifyStrategy {
  const GatewayIdentifyStrategy._();

  /// Identify as a browser client using a browser [name].
  GatewayIdentify asBrowser(
    String name, {
    int largeThreshold: 50,
    PresenceStatus status: PresenceStatus.online,
  }) =>
      new GatewayIdentify._({
        'properties': {
          '\$browser': name,
        },
        'compress': false,
        'large_threshold': largeThreshold,
        'shard': const [0, 1],
        'presence': {
          'status': _toStatusString(status),
          'afk': false,
        },
      });
}

/// JSON-wrapper for identifying connection characteristics to Discord.
class GatewayIdentify {
  final Map<String, Object> _json;

  GatewayIdentify._(this._json);

  Map<String, Object> asJson() => _json;
}

/// Status types.
enum PresenceStatus {
  online,
  doNotDisturb,
  idle,
  invisible,
  offline,
}

String _toStatusString(PresenceStatus status) {
  switch (status) {
    case PresenceStatus.online:
      return 'online';
    case PresenceStatus.doNotDisturb:
      return 'dnd';
    case PresenceStatus.idle:
      return 'idle';
    case PresenceStatus.invisible:
      return 'invisible';
    default:
      return 'offline';
  }
}
