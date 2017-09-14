// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library din.test.clients.http_client_vm_test;

import 'dart:io';
import 'package:din/platform/vm.dart';
import 'package:test/test.dart';

import 'http_client_common.dart';

void main() {
  group('VmHttpClient', () {
    testHttpClient(
      () => const VmHttpClient(),
      'http://localhost:8000/example.json',
      (e) => e is SocketException && e.message.contains('Connection refused'),
    );
  });
}
