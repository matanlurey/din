// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:din/din.dart' as din;
import 'package:din/platform/test.dart';
import 'package:test/test.dart';

void main() {
  group('channel: ', () {
    Map<String, Object> responses;
    din.ChannelsResource channels;

    setUp(() {
      responses = {};
      final restClient = new din.RestClient.withBaseUrl(
        'fake.api',
        auth: new din.AuthScheme.asBot('1234'),
        http: new FakeHttpClient(responses),
      );
      channels = new din.ChannelsResource(restClient);
    });

    test('getChannel', () async {
      responses['GET fake.api/channels/1234'] = {
        'id': '1234',
        'name': 'TalkTalkTalk',
        'topic': 'Talk a lot here',
        'type': din.ChannelType.guildText.index,
        'position': 1,
      };
      final result = await channels.getChannel(id: '1234');
      expect(result.id, '1234');
      expect(result.name, 'TalkTalkTalk');
      expect(result.topic, 'Talk a lot here');
      expect(result.type, din.ChannelType.guildText);
      expect(result.position, 1);
      expect(result.bitRate, isNull);
      expect(result.userLimit, isNull);
    });

    test('getMessages', () async {
      responses['GET fake.api/channels/1234/messages'] = [
        {
          'id': '1234',
          'content': 'Hello World',
          'author': <String, Object>{},
          'timestamp': new DateTime.now().toIso8601String(),
          'mentions_everyone': false,
          'mentions': <Map<String, Object>>[
            <String, Object>{},
          ],
          'nonce': '1234abcd',
          'pinned': true,
          'type': din.MessageType.auto.index,
        },
      ];
      final result = await channels.getMessages(channelId: '1234');
      expect(result, hasLength(1));
      expect(result.first, const isInstanceOf<din.Message>());
      final message = result.first;
      expect(message.id, '1234');
      expect(message.content, 'Hello World');
      expect(message.user, const isInstanceOf<din.User>());
      expect(message.timeStamp, isNotNull);
      expect(message.mentionsEveryone, isFalse);
      expect(message.mentions, hasLength(1));
      expect(message.mentions.first, const isInstanceOf<din.User>());
      expect(message.nonce, '1234abcd');
      expect(message.isPinned, isTrue);
      expect(message.type, din.MessageType.auto);
    });
  });
}
