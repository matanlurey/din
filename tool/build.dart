// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:args/args.dart';
import 'package:build_runner/build_runner.dart';
import 'package:din/src/generators/resource.dart';
import 'package:din/src/generators/structure.dart';
import 'package:source_gen/source_gen.dart';

/// All-in-one tool for generating API classes for this package.
///
/// Simple use: `dart tool/build.dart`.
///
/// May be invoked with `-w` or `--watch` in order to watch for changes.
Future<Null> main(List<String> args) async {
  final results = _argParser.parse(args);
  await (results['watch'] as bool ? watch : build)(
    [
      new BuildAction(
        new PartBuilder(const [
          const ResourceGenerator(),
          const StructureGenerator(),
        ], requireLibraryDirective: false),
        'din',
        inputs: const [
          'lib/src/schema/resources/**.dart',
          'lib/src/schema/structures/**.dart',
        ],
      ),
    ],
    deleteFilesByDefault: true,
  );
}

final _argParser = new ArgParser()..addFlag('watch', abbr: 'w');
