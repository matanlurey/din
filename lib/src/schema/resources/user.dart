// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:din/din.dart';

import '../metadata.dart';
import '../structures/user.dart';

part 'user.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/resources';

@Resource(
  root: 'users',
  docs: '$_resourceBase/user',
)
abstract class UsersResource {
  factory UsersResource(RestClient client) = _$UsersResource;

  /// Returns the [User] of the requester's account.
  @Endpoint(
    method: 'GET',
    path: const ['@me'],
    docs: '$_resourceBase/user#get-current-user',
  )
  Future<User> getCurrentUser();
}
