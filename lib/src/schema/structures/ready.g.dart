// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$ReadyBuilder {
  int version;

  User user;

  List<Channel> privateChannels;

  String sessionId;

  List<String> trace;

  _$Ready _build() {
    return new _$Ready._internal(
      version: version,
      user: user,
      privateChannels: privateChannels,
      sessionId: sessionId,
      trace: trace,
    );
  }
}

class _$Ready implements Ready {
  const _$Ready._internal(
      {this.version,
      this.user,
      this.privateChannels,
      this.sessionId,
      this.trace});

  factory _$Ready(void build(_$ReadyBuilder builder)) {
    final builder = new _$ReadyBuilder();
    build(builder);
    return builder._build();
  }

  factory _$Ready.fromJson(Map<String, Object> json) => (new _$ReadyBuilder()
        ..version = json['v'] as int
        ..user = new User.fromJson(json['user'] as Map<String, Object>)
        ..privateChannels =
            (json['private_channels'] as List<Map<String, Object>>)
                .map((e) => new Channel.fromJson(e))
                .toList()
        ..sessionId = json['session_id'] as String
        ..trace = json['_trade'] as List<String>)
      ._build();

  @override
  final int version;

  @override
  final User user;

  @override
  final List<Channel> privateChannels;

  @override
  final String sessionId;

  @override
  final List<String> trace;
}
