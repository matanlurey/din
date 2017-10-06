// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';
import 'channel.dart';
import 'user.dart';

part 'ready.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/topics/gateway';

@Structure(
  docs: '$_resourceBase#ready',
)
abstract class Ready {
  factory Ready(
    void build(_$ReadyBuilder builder),
  ) = _$Ready;

  factory Ready.fromJson(
    Map<String, Object> json,
  ) = _$Ready.fromJson;

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
