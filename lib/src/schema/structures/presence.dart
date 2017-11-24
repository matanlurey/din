// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';
import 'user.dart';

part 'presence.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/topics/gateway';

@Structure(
  docs: '$_resourceBase#presence-update',
)
abstract class PresenceUpdate {
  factory PresenceUpdate(
    void build(_$PresenceUpdateBuilder builder),
  ) = _$PresenceUpdate;

  factory PresenceUpdate.fromJson(
    Map<String, Object> json,
  ) = _$PresenceUpdate.fromJson;

  @Field(name: 'user')
  User get user;

  @Field(name: 'status')
  String get status;
}
