// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guild.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$GuildBuilder {
  List<PresenceUpdate> presences;

  _$Guild _build() {
    return new _$Guild._internal(
      presences: presences,
    );
  }
}

class _$Guild implements Guild {
  const _$Guild._internal({this.presences});

  factory _$Guild(void build(_$GuildBuilder builder)) {
    final builder = new _$GuildBuilder();
    build(builder);
    return builder._build();
  }

  factory _$Guild.fromJson(Map<String, Object> json) => json == null
      ? null
      : (new _$GuildBuilder()
            ..presences = (json.containsKey('presences')
                    ? json['presences'] as List<Map<String, Object>>
                    : const <Map<String, Object>>[])
                .map((e) => new PresenceUpdate.fromJson(e))
                .toList())
          ._build();

  @override
  final List<PresenceUpdate> presences;
}
