// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:async/async.dart';
import 'package:din/din.dart' as din;

/// A simple [HttpClient] that replies to HTTP requests with preset responses.
class FakeHttpClient implements din.HttpClient {
  final Map<String, Object> _results;

  const FakeHttpClient(this._results);

  @override
  CancelableOperation<Object> requestJson(
    String path, {
    String method: 'GET',
    Map<String, Object> payload,
    Map<String, String> headers,
  }) {
    final completer = new CancelableCompleter<Object>();
    final response = _results['$method $path'];
    if (response == null) {
      completer.completeError(
        new din.HttpClientException(500, 'No response for "$method $path"'),
      );
    } else {
      completer.complete(response);
    }
    return completer.operation;
  }
}
