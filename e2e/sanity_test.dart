// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library din.e2e.sanity_test;

import 'dart:async';
import 'dart:io';

import 'package:din/din.dart' as din;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Executes a simple end-to-end test that actually connects to the Discord API.
///
/// It is highly recommended to only run on release or a timed system like a
/// cron job in order to avoid hurting Discord's servers, hence why these tests
/// are not included in the `test/` folder.
Future<Null> main() async {
  // See README.md#testing for details.
  //
  // tl;dr connects to a server, and checks that a channel name is "bots".
  final e2eConfig = new File('e2e/config.yaml');
  String apiToken;
  String channelId;
  String expectChannelName;
  String expectUserName;
  if (e2eConfig.existsSync()) {
    final yamlConfig = loadYaml(
      e2eConfig.readAsStringSync(),
    ) as Map<String, Object>;
    apiToken = yamlConfig['api_token'] as String;
    channelId = yamlConfig['channel_id'] as String;
    expectChannelName = yamlConfig['channel_name'] as String;
    expectUserName = yamlConfig['user_name'] as String;
  } else {
    apiToken = Platform.environment['DISCORD_API_TOKEN'];
    channelId = Platform.environment['DISCORD_CHANNEL_ID'];
    expectUserName = Platform.environment['DISCORD_USER_NAME'];
  }
  expectChannelName ??= 'bots';
  if (apiToken == null || apiToken.isEmpty) {
    fail('Could not find DISCORD_API_TOKEN on PATH or in ${e2eConfig.path}.');
    exitCode = 1;
    return;
  } else {
    print('DISCORD_API_TOKEN   = ${'*' * apiToken.length}');
    print('DISCORD_CHANNEL_ID  = ${'*' * channelId.length}');
  }
  final apiClient = new din.ApiClient(
    rest: new din.RestClient(
      auth: new din.AuthScheme.asBot(apiToken),
    ),
  );

  // Give a second of back-off between API requests.
  setUp(() => new Future<Null>.delayed(const Duration(seconds: 1)));

  test('should retrieve a channel named "$expectChannelName"', () async {
    final channel = await apiClient.channels.getChannel(id: channelId);
    expect(channel.name, expectChannelName);
    expect(channel.type, din.ChannelType.guildText);
  });

  test('should post a message in the channel', () async {
    final now = new DateTime.now().toIso8601String();
    final message = await apiClient.channels.createMessage(
      channelId: channelId,
      content: 'Hello World @ $now',
    );
    expect(message.content, 'Hello World @ $now');
  });

  test('should retrieve the current user', () async {
    final user = await apiClient.users.getCurrentUser();
    expect(user.name, expectUserName);
  });

  test('should return previous messages', () async {
    final messages = await apiClient.channels.getMessages(channelId: channelId);
    expect(messages, isList);
  });

  test('should return a WSS gateway and be able to connect to it', () async {
    final gateway = await apiClient.gateway.getGatewayBot();
    expect(gateway.url, isNotEmpty);
    expect(gateway.shards, greaterThan(0));

    final connection = await apiClient.connect(gateway.url);
    expect(connection.onHello, completion(isList));
    expect(
      connection.onSequenceUpdate.first,
      completion(isNotNull),
      reason: 'Should receive an initial sequence number',
    );
    final readyEvent = await connection.events.ready.first;
    expect(readyEvent.user, isNotNull);
    await connection.close();
    expect(await connection.onClose, isNull);
  });
}
