// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:din/din.dart';
import 'package:test/test.dart';

void testHttpClient(
  HttpClient Function() create,
  String url,
  bool Function(Object exception) isConnectionError,
) {
  HttpClient client;

  setUp(() => client = create());

  test('should fetch a simple JSON file', () async {
    try {
      final value = await client.requestJson(url).value;
      expect(value, {
        'name': 'din',
      });
    } catch (e) {
      if (isConnectionError(e)) {
        fail(''
            'Connection has failed. Have you started the static web server?\n'
            'See README.md#testing for more information.');
      }
      rethrow;
    }
  });
}
