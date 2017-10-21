// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import '../schema/structures/channel.dart';
import '../schema/structures/gateway.dart';
import '../schema/structures/message.dart';
import '../schema/structures/ready.dart';

class GatewayEvents {
  final _channelCreate = new StreamController<Channel>.broadcast();
  final _channelUpdate = new StreamController<Channel>.broadcast();
  final _channelDelete = new StreamController<Channel>.broadcast();
  final _messageCreate = new StreamController<Message>.broadcast();
  final _messageUpdate = new StreamController<Message>.broadcast();
  final _ready = new StreamController<Ready>.broadcast();

  final StreamSink<int> _onSequenceUpdate;

  /// Create a listener to a raw [events] stream from a gateway server.
  GatewayEvents(Stream<GatewayDispatch> events, this._onSequenceUpdate) {
    events.listen((event) {
      if (event.sequence != null) {
        _onSequenceUpdate.add(event.sequence);
      }
      try {
        _parseEvent(event);
      } catch (e, s) {
        // TODO: It would be preferable to only catch precisely parse errors.
        throw new FormatException(
          ''
              'Failed to parse incoming event ${event.name}\n'
              '\n\n'
              'Source: $e\n'
              '$s\n',
          JSON.encode(event.data),
        );
      }
    });
  }

  void _parseEvent(GatewayDispatch event) {
    switch (event.name) {
      case 'CHANNEL_CREATE':
        _channelCreate.add(new Channel.fromJson(
          event.data as Map<String, Object>,
        ));
        break;
      case 'CHANNEL_UPDATE':
        _channelUpdate.add(new Channel.fromJson(
          event.data as Map<String, Object>,
        ));
        break;
      case 'CHANNEL_DELETE':
        _channelDelete.add(new Channel.fromJson(
          event.data as Map<String, Object>,
        ));
        break;
      case 'MESSAGE_CREATE':
        _messageCreate.add(new Message.fromJson(
          event.data as Map<String, Object>,
        ));
        break;
      case 'MESSAGE_UPDATE':
        _messageUpdate.add(new Message.fromJson(
          event.data as Map<String, Object>,
        ));
        break;
      case 'READY':
        _ready.add(new Ready.fromJson(
          event.data as Map<String, Object>,
        ));
        break;
    }
  }

  /// Sent when a new channel is created, relevant to the current user.
  Stream<Channel> get channelCreate => _channelCreate.stream;

  /// Sent when a channel is updated.
  Stream<Channel> get channelUpdate => _channelUpdate.stream;

  /// Sent when a channel relevant to the current user is deleted.
  Stream<Channel> get channelDelete => _channelDelete.stream;

  // TODO: Channel Pins Update.
  // TODO: Guild Create.
  // TODO: Guild Update.
  // TODO: Guild Delete.
  // TODO: Guild Ban Add.
  // TODO: Guild Ban Remove.
  // TODO: Guild Emojis Update.
  // TODO: Guild Integrations Update.
  // TODO: Guild Member Add.
  // TODO: Guild Member Remove.
  // TODO: Guild Member Update.
  // TODO: Guild Members Chunk.
  // TODO: Guild Role Create.
  // TODO: Guild Role Update.
  // TODO: Guild Role Delete.

  /// Sent when a message is created.
  Stream<Message> get messageCreate => _messageCreate.stream;

  /// Sent when a message is updated.
  Stream<Message> get messageUpdate => _messageUpdate.stream;

  // TODO: Message Delete.
  // TODO: Message Delete Bulk.
  // TODO: Message Reaction Add.
  // TODO: Message Reaction Remove.
  // TODO: Message Reaction Remove All.
  // TODO: Presence Update.
  // TODO: Typing Start.
  // TODO: User Update.
  // TODO: Voice State Update.
  // TODO: Voice Server Update.
  // TODO: Webhooks Update.

  /// Sent on initial identification.
  Stream<Ready> get ready => _ready.stream;
}
