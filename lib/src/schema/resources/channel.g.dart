// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// Generator: ResourceGenerator
// **************************************************************************

class _$ChannelsResource implements ChannelsResource {
  _$ChannelsResource(this._restClient);
  final RestClient _restClient;
  @override
  Future<Channel> getChannel({String id}) {
    return _restClient
        .request(
          url: 'channels/$id',
          method: 'GET',
        )
        .then((json) => new Channel.fromJson(json));
  }
}
