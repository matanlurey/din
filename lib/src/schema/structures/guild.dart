// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../metadata.dart';
import 'presence.dart';

part 'guild.g.dart';

const _resourceBase = 'https://discordapp.com/developers/docs/topics/gateway';

@Structure(
  docs: '$_resourceBase#guild',
)
abstract class Guild {
  factory Guild(
    void build(_$GuildBuilder builder),
  ) = _$Guild;

  factory Guild.fromJson(
    Map<String, Object> json,
  ) = _$Guild.fromJson;

  @Field(name: 'presences')
  List<PresenceUpdate> get presences;
}
