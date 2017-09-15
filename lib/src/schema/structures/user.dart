// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';

part 'user.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/resources';

@Structure(
  docs: '$_resourceBase/user#user-object',
)
abstract class User {
  factory User(void build(_$UserBuilder builder)) = _$User;
  factory User.fromJson(Map<String, Object> json) = _$User.fromJson;

  @Field(name: 'id')
  String get id;

  @Field(name: 'username')
  String get name;
}
