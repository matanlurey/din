// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';
import 'channel.dart';
import 'user.dart';

part 'gateway.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/topics/gateway';

@Structure(
  docs: '$_resourceBase#get-gateway',
)
abstract class Gateway {
  factory Gateway(void build(_$GatewayBuilder builder)) = _$Gateway;
  factory Gateway.fromJson(Map<String, Object> json) = _$Gateway.fromJson;

  @Field(name: 'url')
  String get url;

  @Field(name: 'shards')
  int get shards;
}

@Structure(
  docs: '$_resourceBase#gateway-dispatch',
)
abstract class GatewayDispatch {
  factory GatewayDispatch(
    void build(_$GatewayDispatchBuilder builder),
  ) = _$GatewayDispatch;
  factory GatewayDispatch.fromJson(
    Map<String, Object> json,
  ) = _$GatewayDispatch.fromJson;

  @Field(name: 'op')
  GatewayOpcode get op;

  @Field(name: 'd')
  Object get data;

  @Field(name: 's', optional: true)
  int get sequence;

  @Field(name: 't', optional: true)
  String get name;
}

enum GatewayOpcode {
  dispatch,
  heartbeat,
  identify,
  statusUpdate,
  voiceStateUpdate,
  voiceServerPing,
  resume,
  reconnect,
  requestGuildMembers,
  invalidSession,
  hello,
  heartbeatAck,
}

@Structure(
  docs: '$_resourceBase#ready',
)
abstract class GatewayReady {
  factory GatewayReady(
    void build(_$GatewayReadyBuilder builder),
  ) = _$GatewayReady;

  factory GatewayReady.fromJson(
    Map<String, Object> json,
  ) = _$GatewayReady.fromJson;

  @Field(name: 'v')
  int get version;

  @Field(name: 'user')
  User get user;

  @Field(name: 'private_channels')
  List<Channel> get privateChannels;

  @Field(name: 'session_id')
  String get sessionId;

  @Field(name: '_trade')
  List<String> get trace;
}
