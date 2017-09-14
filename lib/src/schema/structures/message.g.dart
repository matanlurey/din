// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$MessageBuilder {
  String id;
  String content;
  _$Message _build() {
    return new _$Message._internal(
      id: id,
      content: content,
    );
  }
}

class _$Message implements Message {
  const _$Message._internal({this.id, this.content});
  factory _$Message(void build(_$MessageBuilder builder)) {
    final builder = new _$MessageBuilder();
    build(builder);
    return builder._build();
  }
  factory _$Message.fromJson(Map<String, Object> json) =>
      (new _$MessageBuilder()
            ..id = json['id'] as String
            ..content = json['content'] as String)
          ._build();
  @override
  final String id;
  @override
  final String content;
}
