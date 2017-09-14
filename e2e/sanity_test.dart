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
  if (e2eConfig.existsSync()) {
    final yamlConfig = loadYaml(
      e2eConfig.readAsStringSync(),
    ) as Map<String, Object>;
    apiToken = yamlConfig['api_token'] as String;
    channelId = yamlConfig['channel_id'] as String;
    expectChannelName = yamlConfig['channel_name'] as String;
  } else {
    apiToken = Platform.environment['DISCORD_API_TOKEN'];
    channelId = Platform.environment['DISCORD_CHANNEL_ID'];
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

  test('should retrieve a channel named "$expectChannelName"', () async {
    final channel = await apiClient.channels.getChannel(id: channelId);
    expect(channel.name, expectChannelName);
  });
}
