// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$PresenceUpdateBuilder {
  User user;

  String status;

  _$PresenceUpdate _build() {
    return new _$PresenceUpdate._internal(
      user: user,
      status: status,
    );
  }
}

class _$PresenceUpdate implements PresenceUpdate {
  const _$PresenceUpdate._internal({this.user, this.status});

  factory _$PresenceUpdate(void build(_$PresenceUpdateBuilder builder)) {
    final builder = new _$PresenceUpdateBuilder();
    build(builder);
    return builder._build();
  }

  factory _$PresenceUpdate.fromJson(Map<String, Object> json) => json == null
      ? null
      : (new _$PresenceUpdateBuilder()
            ..user = new User.fromJson(json['user'] as Map<String, Object>)
            ..status = json['status'] as String)
          ._build();

  @override
  final User user;

  @override
  final String status;
}
