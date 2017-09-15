// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';

part 'channel.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/resources';

@Structure(
  docs: '$_resourceBase/channel#channel-object',
)
abstract class Channel {
  factory Channel(void build(_$ChannelBuilder builder)) = _$Channel;
  factory Channel.fromJson(Map<String, Object> json) = _$Channel.fromJson;

  @Field(name: 'id')
  String get id;

  @Field(name: 'name', optional: true)
  String get name;

  @Field(name: 'topic', optional: true)
  String get topic;

  @Field(name: 'type')
  ChannelType get type;

  @Field(name: 'position')
  int get position;

  @Field(name: 'bitrate', optional: true)
  int get bitRate;

  @Field(name: 'userLimit', optional: true)
  int get userLimit;
}

enum ChannelType {
  guildText,
  directMessage,
  guildVoice,
  groupDirectMessage,
  guildCategory,
}
