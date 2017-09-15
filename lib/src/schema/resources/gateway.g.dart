// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway.dart';

// **************************************************************************
// Generator: ResourceGenerator
// **************************************************************************

class _$GatewayResource implements GatewayResource {
  _$GatewayResource(this._restClient);
  final RestClient _restClient;
  @override
  Future<Gateway> getGateway() {
    return _restClient
        .request(
          url: 'gateway',
          method: 'GET',
        )
        .then((json) => new Gateway.fromJson(json as Map<String, Object>));
  }

  @override
  Future<Gateway> getGatewayBot() {
    return _restClient
        .request(
          url: 'gateway/bot',
          method: 'GET',
        )
        .then((json) => new Gateway.fromJson(json as Map<String, Object>));
  }
}
