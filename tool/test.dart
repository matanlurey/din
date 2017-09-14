// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:io/io.dart';

/// All-in-one tool for running test cases for this package.
///
/// Simple use: `dart tool/test.dart`.
Future<Null> main() async {
  // Spawn all processes in background/headless mode:
  // https://github.com/dart-lang/io/issues/18
  final manager = new ProcessManager(stdin: const Stream.empty());

  print('Starting HTTP server...');
  final staticHttpServer = await manager.spawn(
    'dart',
    arguments: [
      'tool/servers/static.dart',
    ],
  );
  print('Starting "pub run test"...');
  final pubRunTest = await manager.spawn('pub', arguments: [
    'run',
    'test',
  ]);

  final result = await pubRunTest.exitCode;
  print('Terminating...');
  staticHttpServer.kill();
  exitCode = result;
}
