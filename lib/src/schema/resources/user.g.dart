// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// Generator: ResourceGenerator
// **************************************************************************

class _$UsersResource implements UsersResource {
  _$UsersResource(this._restClient);

  final RestClient _restClient;

  @override
  Future<User> getCurrentUser() {
    return _restClient
        .request(
          url: 'users/@me',
          method: 'GET',
        )
        .then((json) => new User.fromJson(json as Map<String, Object>));
  }
}
