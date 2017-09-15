// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Abstraction around authentication to the Discord API server.
///
/// Only _bot_ authentication is currently supported ([AuthScheme.asBot]).
///
/// [More info](https://discordapp.com/developers/docs/reference#authentication).
abstract class AuthScheme {
  factory AuthScheme.asBot(String token) = _BotAuthScheme;

  /// HTTP header value.
  String get headerValue;

  /// Token.
  String get token;
}

class _BotAuthScheme implements AuthScheme {
  const _BotAuthScheme(this.token);

  @override
  String get headerValue => 'Bot $token';

  @override
  final String token;
}
