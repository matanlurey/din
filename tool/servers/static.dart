// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

/// Runs a static web server hosting content on `tool/servers/static`.
///
/// Used for some simple HTTP client tests in this package.
Future<Null> main(List<String> args) async {
  final results = _argParser.parse(args);
  final server = await serve(
    createStaticHandler('tool/servers/static'),
    results['host'],
    int.parse(results['port'] as String),
  );
  print('Listening to ${results['host']}:${results['port']}...');
  _onTerminate.first.then((_) {
    print('\nReceived termination request. Shutting down...');
    server.close();
    exitCode = 0;
  });
}

final _argParser = new ArgParser()
  ..addOption('host', abbr: 'h', defaultsTo: '0.0.0.0')
  ..addOption('port', abbr: 'p', defaultsTo: '8000');

// https://github.com/dart-lang/io/issues/17
Stream<Null> get _onTerminate => ProcessSignal.SIGINT.watch().map((_) => null);
