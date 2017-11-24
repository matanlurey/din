// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';
import 'user.dart';

part 'message.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/resources';

@Structure(
  docs: '$_resourceBase/channel#message-object',
)
abstract class Message {
  factory Message(void build(_$MessageBuilder builder)) = _$Message;
  factory Message.fromJson(Map<String, Object> json) = _$Message.fromJson;

  @Field(name: 'id')
  String get id;

  @Field(name: 'channel_id', optional: true)
  String get channelId;

  @Field(name: 'content')
  String get content;

  @Field(name: 'author', optional: true)
  User get user;

  @Field(name: 'timestamp')
  DateTime get timeStamp;

  @Field(name: 'mentions_everyone')
  bool get mentionsEveryone;

  @Field(name: 'mentions')
  List<User> get mentions;

  @Field(name: 'nonce')
  String get nonce;

  @Field(name: 'pinned')
  bool get isPinned;

  @Field(name: 'type')
  MessageType get type;
}

enum MessageType {
  auto,
  recipientAdd,
  recipientRemove,
  call,
  channelNameChange,
  channelIconChange,
  channelPinnedMessage,
  guildMemberJoin,
}
