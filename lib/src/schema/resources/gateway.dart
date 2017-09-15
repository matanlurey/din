// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:din/din.dart';

import '../metadata.dart';
import '../structures/gateway.dart';

part 'gateway.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/topics/gateway';

@Resource(
  root: 'gateway',
  docs: '$_resourceBase',
)
abstract class GatewayResource {
  factory GatewayResource(RestClient client) = _$GatewayResource;

  /// Returns an object with a single WSS URL.
  ///
  /// Clients **should** cache this value and only call this endpoint to
  /// retrieve a new URL if they are unable to properly establish a connection
  /// using the cached version of the URL.
  @Endpoint(
    method: 'GET',
    path: const [],
    docs: '$_resourceBase#get-gateway',
  )
  Future<Gateway> getGateway();

  /// Returns an object similar to [getGateway], including [Gateway.shards].
  ///
  /// Unlike [getGateway], this route should not be cached for extended periods
  /// of time as the value is not guaranteed to be the same per-call and changes
  /// as the bot joins/leaves guilds.
  @Endpoint(
    method: 'GET',
    path: const ['bot'],
    docs: '$_resourceBase#get-gateway-bot',
  )
  Future<Gateway> getGatewayBot();
}
