// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$UserBuilder {
  String id;

  String name;

  _$User _build() {
    return new _$User._internal(
      id: id,
      name: name,
    );
  }
}

class _$User implements User {
  const _$User._internal({this.id, this.name});

  factory _$User(void build(_$UserBuilder builder)) {
    final builder = new _$UserBuilder();
    build(builder);
    return builder._build();
  }

  factory _$User.fromJson(Map<String, Object> json) => json == null
      ? null
      : (new _$UserBuilder()
            ..id = json['id'] as String
            ..name = json['username'] as String)
          ._build();

  @override
  final String id;

  @override
  final String name;
}
