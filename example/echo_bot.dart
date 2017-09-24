// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:din/din.dart' as din;

Future<Null> main() async {
  final apiToken = Platform.environment['DISCORD_API_TOKEN'];

  final apiClient = new din.ApiClient(
    rest: new din.RestClient(
      auth: new din.AuthScheme.asBot(apiToken),
    ),
  );

  final gateway = await apiClient.gateway.getGatewayBot();
  print('Gateway: ${gateway.url}. Connecting...');

  final gatewayClient = await apiClient.connect(gateway.url);
  print('Connected! Authenticating...');

  final helloTraces = await gatewayClient.onHello;
  final readyMessage = await gatewayClient.events.ready.first;
  print('Authenticated! Connected through $helloTraces.');

  ProcessSignal.SIGTERM.watch().listen((_) {
    gatewayClient.close();
    exitCode = 0;
  });

  await for (final message in gatewayClient.events.messageCreate) {
    if (message.user.id != readyMessage.user.id) {
      apiClient.channels.createMessage(
        channelId: message.channelId,
        content: '[ECHO] ${message.user.name} said "${message.content}"',
      );
    }
  }
}
