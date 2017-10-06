// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway.dart';

// **************************************************************************
// Generator: StructureGenerator
// **************************************************************************

class _$GatewayBuilder {
  String url;
  int shards;
  _$Gateway _build() {
    return new _$Gateway._internal(
      url: url,
      shards: shards,
    );
  }
}

class _$Gateway implements Gateway {
  const _$Gateway._internal({this.url, this.shards});
  factory _$Gateway(void build(_$GatewayBuilder builder)) {
    final builder = new _$GatewayBuilder();
    build(builder);
    return builder._build();
  }
  factory _$Gateway.fromJson(Map<String, Object> json) =>
      (new _$GatewayBuilder()
            ..url = json['url'] as String
            ..shards = json['shards'] as int)
          ._build();
  @override
  final String url;
  @override
  final int shards;
}

class _$GatewayDispatchBuilder {
  GatewayOpcode op;
  Object data;
  int sequence;
  String name;
  _$GatewayDispatch _build() {
    return new _$GatewayDispatch._internal(
      op: op,
      data: data,
      sequence: sequence,
      name: name,
    );
  }
}

class _$GatewayDispatch implements GatewayDispatch {
  const _$GatewayDispatch._internal(
      {this.op, this.data, this.sequence, this.name});
  factory _$GatewayDispatch(void build(_$GatewayDispatchBuilder builder)) {
    final builder = new _$GatewayDispatchBuilder();
    build(builder);
    return builder._build();
  }
  factory _$GatewayDispatch.fromJson(Map<String, Object> json) =>
      (new _$GatewayDispatchBuilder()
            ..op = GatewayOpcode.values[json['op'] as int]
            ..data = json['d']
            ..sequence = json['s'] as int
            ..name = json['t'] as String)
          ._build();
  @override
  final GatewayOpcode op;
  @override
  final Object data;
  @override
  final int sequence;
  @override
  final String name;
}
