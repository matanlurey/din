// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';

part 'message.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/resources';

@Structure(
  docs: '$_resourceBase/channel#message-object',
)
abstract class Message {
  factory Message(void build(_$MessageBuilder builder)) = _$Message;
  factory Message.fromJson(Map<String, Object> json) = _$Message.fromJson;

  @Field(
    name: 'id',
    type: FieldType.snowflake,
  )
  String get id;

  @Field(
    name: 'content',
  )
  String get content;
}
