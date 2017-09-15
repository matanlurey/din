// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';

import '../../platform/vm.dart';
import '../schema/resources/channel.dart';
import '../schema/resources/gateway.dart';
import '../schema/resources/user.dart';
import 'gateway_client.dart';
import 'rest_client.dart';
import 'ws_client.dart';

/// A higher-level abstraction on top of [RestClient] for making API calls.
class ApiClient {
  final GatewayClientFactory _gateway;
  final RestClient _rest;

  const ApiClient({
    GatewayClientFactory gateway: GatewayClient.connect,
    @required RestClient rest,
  })
      : _gateway = gateway,
        _rest = rest;

  /// Connects to the message gateway.
  Future<GatewayClient> connect(
    String url, [
    WebSocketFactory webSocket = VmWebSocketClient.connect,
  ]) =>
      _gateway(webSocket, '$url?v=6&encoding=json', _rest);

  /// Accesses the `channels` resource of the Discord API.
  ChannelsResource get channels => new ChannelsResource(_rest);

  /// Accesses the `gateway` resource of the Discord API.
  GatewayResource get gateway => new GatewayResource(_rest);

  /// Accesses the `users` resource of the Discord API.
  UsersResource get users => new UsersResource(_rest);
}
