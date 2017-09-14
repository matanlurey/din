// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$ChannelBuilder {
  String id;
  String name;
  _$Channel _build() {
    return new _$Channel._internal(
      id: id,
      name: name,
    );
  }
}

class _$Channel implements Channel {
  const _$Channel._internal({this.id, this.name});
  factory _$Channel(void build(_$ChannelBuilder builder)) {
    final builder = new _$ChannelBuilder();
    build(builder);
    return builder._build();
  }
  factory _$Channel.fromJson(Map<String, Object> json) =>
      (new _$ChannelBuilder()
            ..id = json['id'] as String
            ..name = json['name'] as String)
          ._build();
  @override
  final String id;
  @override
  final String name;
}
