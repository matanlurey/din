// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Defines the `User-Agent` header that is sent to the Discord API.
class UserAgent {
  /// Recommended default value of [UserAgent] if omitted.
  static const UserAgent defaultDin = const UserAgent(
    'https://pub.dartlang.org/din',
    '0.1.0',
  );

  /// Value of the header that will be sent.
  final String headerValue;

  /// Creates a new [UserAgent] in the required format of the Discord API.
  ///
  /// [More info](https://discordapp.com/developers/docs/reference#user-agent).
  const UserAgent(String url, String version, [String metadata])
      : this.custom(
          'DiscordBot ($url, $version)${metadata == null ? '' : ' $metadata'}',
        );

  /// Creates a custom `User-Agent` header value.
  const UserAgent.custom(this.headerValue);

  @override
  int get hashCode => headerValue.hashCode;

  @override
  bool operator ==(Object o) => o is UserAgent && o.headerValue == headerValue;

  @override
  String toString() => headerValue;
}
