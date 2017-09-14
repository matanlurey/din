// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:din/din.dart' as din;

/// Implements [HttpClient] for both the standalone Dart VM and Flutter.
class VmHttpClient implements din.HttpClient {
  static HttpClient _defaultHttpClient() => new HttpClient();

  final HttpClient Function() _createHttpClient;

  const VmHttpClient([this._createHttpClient = _defaultHttpClient]);

  @override
  CancelableOperation<Map<String, Object>> requestJson(
    String path, {
    String method: 'GET',
    Map<String, Object> payload,
    Map<String, String> headers: const {},
  }) {
    final client = _createHttpClient();
    var isCancelled = false;
    void Function() onCancel;
    final completer = new CancelableCompleter<Map<String, Object>>(
      onCancel: () {
        isCancelled = true;
        if (onCancel != null) {
          onCancel();
        }
      },
    );
    client.openUrl(method, Uri.parse(path)).then((request) {
      onCancel = () {
        request.close();
      };
      if (isCancelled) {
        onCancel();
        return;
      }
      headers.forEach(request.headers.set);
      if (payload != null) {
        request.write(JSON.encode(payload));
      }
      request.close();
      request.done.then((response) async {
        // TODO: Make this more robust, and throw an HttpException.
        if (response.statusCode >= 400) {
          final error = '${response.statusCode}: ${response.reasonPhrase}';
          completer.completeError(error);
          return;
        }
        completer.complete(JSON.decode(await UTF8.decodeStream(response)));
        client.close();
      }, onError: completer.completeError);
    });
    return completer.operation;
  }
}
