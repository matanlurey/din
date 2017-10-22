// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$MessageBuilder {
  String id;

  String channelId;

  String content;

  User user;

  DateTime timeStamp;

  bool mentionsEveryone;

  List<User> mentions;

  String nonce;

  bool isPinned;

  MessageType type;

  _$Message _build() {
    return new _$Message._internal(
      id: id,
      channelId: channelId,
      content: content,
      user: user,
      timeStamp: timeStamp,
      mentionsEveryone: mentionsEveryone,
      mentions: mentions,
      nonce: nonce,
      isPinned: isPinned,
      type: type,
    );
  }
}

class _$Message implements Message {
  const _$Message._internal(
      {this.id,
      this.channelId,
      this.content,
      this.user,
      this.timeStamp,
      this.mentionsEveryone,
      this.mentions,
      this.nonce,
      this.isPinned,
      this.type});

  factory _$Message(void build(_$MessageBuilder builder)) {
    final builder = new _$MessageBuilder();
    build(builder);
    return builder._build();
  }

  factory _$Message.fromJson(Map<String, Object> json) => json == null
      ? null
      : (new _$MessageBuilder()
            ..id = json['id'] as String
            ..channelId = json['channel_id'] as String
            ..content = json['content'] as String
            ..user = new User.fromJson(json['author'] as Map<String, Object>)
            ..timeStamp = DateTime.parse(json['timestamp'] as String)
            ..mentionsEveryone = json['mentions_everyone'] as bool
            ..mentions = (json['mentions'] as List<Map<String, Object>>)
                .map((e) => new User.fromJson(e))
                .toList()
            ..nonce = json['nonce'] as String
            ..isPinned = json['pinned'] as bool
            ..type = MessageType.values[json['type'] as int])
          ._build();

  @override
  final String id;

  @override
  final String channelId;

  @override
  final String content;

  @override
  final User user;

  @override
  final DateTime timeStamp;

  @override
  final bool mentionsEveryone;

  @override
  final List<User> mentions;

  @override
  final String nonce;

  @override
  final bool isPinned;

  @override
  final MessageType type;
}
