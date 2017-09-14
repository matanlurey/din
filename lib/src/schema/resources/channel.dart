// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:din/din.dart';
import 'package:meta/meta.dart';

import '../metadata.dart';
import '../structures/channel.dart';
import '../structures/message.dart';

part 'channel.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/resources';

@Resource(
  root: 'channels',
  docs: '$_resourceBase/channel#channels-resource',
)
abstract class ChannelsResource {
  factory ChannelsResource(RestClient client) = _$ChannelsResource;

  /// Get a channel by [id].
  ///
  /// Returns either a [Channel] object.
  @Endpoint(
    method: 'GET',
    path: const [#id],
    docs: '$_resourceBase/channel#get-channel',
  )
  Future<Channel> getChannel({
    @required String id,
  });

  /// Creates a message in [channelId] with text [content].
  ///
  /// Returns a created [Message] object.
  @Endpoint.asJson(
    method: 'POST',
    path: const [#channelId, 'messages'],
    docs: '$_resourceBase/channel#create-message',
  )
  Future<Message> createMessage({
    @required String channelId,
    @required String content,
  });
}
