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

  @Field(
    name: 'id',
    type: FieldType.snowflake,
  )
  String get id;

  @Field(
    name: 'name',
    nullable: true,
  )
  String get name;
}
