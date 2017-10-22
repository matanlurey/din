// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$ChannelBuilder {
  String id;

  String name;

  String topic;

  ChannelType type;

  int position;

  int bitRate;

  int userLimit;

  _$Channel _build() {
    return new _$Channel._internal(
      id: id,
      name: name,
      topic: topic,
      type: type,
      position: position,
      bitRate: bitRate,
      userLimit: userLimit,
    );
  }
}

class _$Channel implements Channel {
  const _$Channel._internal(
      {this.id,
      this.name,
      this.topic,
      this.type,
      this.position,
      this.bitRate,
      this.userLimit});

  factory _$Channel(void build(_$ChannelBuilder builder)) {
    final builder = new _$ChannelBuilder();
    build(builder);
    return builder._build();
  }

  factory _$Channel.fromJson(Map<String, Object> json) => json == null
      ? null
      : (new _$ChannelBuilder()
            ..id = json['id'] as String
            ..name = json['name'] as String
            ..topic = json['topic'] as String
            ..type = ChannelType.values[json['type'] as int]
            ..position = json['position'] as int
            ..bitRate = json['bitrate'] as int
            ..userLimit = json['userLimit'] as int)
          ._build();

  @override
  final String id;

  @override
  final String name;

  @override
  final String topic;

  @override
  final ChannelType type;

  @override
  final int position;

  @override
  final int bitRate;

  @override
  final int userLimit;
}
