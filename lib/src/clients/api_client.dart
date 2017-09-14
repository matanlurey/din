// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import '../schema/resources/channel.dart';
import 'rest_client.dart';

/// A higher-level abstraction on top of [RestClient] for making API calls.
class ApiClient {
  final RestClient _rest;

  const ApiClient({
    @required RestClient rest,
  })
      : _rest = rest;

  /// Accesses the `channels` resource of the Discord API.
  ChannelsResource get channels => new ChannelsResource(_rest);
}
