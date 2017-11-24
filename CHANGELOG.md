## 0.1.0-alpha+8

* Made JSON parse failures more debuggable - throws a `FormatException`.
* Fixed a number of subtle bugs in the generated JSON parsers. 

## 0.1.0-alpha+7

* Updated to `code_builder: ^2.0.0-alpha+3`.

* Fixed a bug where `List<Structure>` types always returned `List<Map>`. [#11](https://github.com/matanlurey/din/issues/11)

* Split most of the Gateway events into `GatewayClient.events`.
* Renamed `GatewayReady` to `Ready`, and moved to `GatewayEvents.ready`.
* Add support for resuming a connection (`ApiClient.resume`).

## 0.1.0-alpha+6

* Added `FakeHttpClient` in `platform/test.dart` for simple testing.
* Changed `GatewayClient.onMessage` to emit a `Message` payload.
* Fixed a bug in the heartbeat mechanic.
* Added `Message#channelId`.

## 0.1.0-alpha+5

* `HttpClient` now throws an `HttpClientException` on an HTTP or network error.
* `WebSocketClient`, `GatewayClient` now support `Future<String> get onClose`.
* Added ability to customize the initial identification to `GatewayClient`:

```dart
doConnect() async {
  await apiClient.connect(gateway.url, onIdentify: (strategy) {
    return strategy.asBrowser('...');
  });
}
```

* `GatewayClient#onReady` now returns a `GatewayReady` event.
* `GatewayClient#onSequence` emits sequence codes, when received. These are
   used internally to reply to heartbeats, but will also be usable in a future
   release to do a _resume_ action (instead of an initial connection).

## 0.1.0-alpha+4

* Added incomplete web socket and gateway support:

```dart
test('should return a WSS gateway and be able to connect to it', () async {
  final gateway = await apiClient.gateway.getGatewayBot();
  expect(gateway.url, isNotEmpty);
  expect(gateway.shards, greaterThan(0));

  final connection = await apiClient.connect(gateway.url);
  expect(await connection.onHello, isList);
  expect(await connection.onReady, isNotNull);
  await connection.close();
});
```

## 0.1.0-alpha+3

* Now exporting structures and resources via the main `din.dart` import.
* Changes the definition of REST/requestJson to `Object` (may be a `List`)
* Renamed `Field#nullable` to `Field#optional`.
* Removed `Field.type` and `FieldType` which was not used.
* Added `channels.getMessages`, adding support for APIs that return `List<T>`.
* Added more fields to `Channel`, `ChannelType`, and support for `enum` types.
* Added support for `DateTime` from an ISO date string.

## 0.1.0-alpha+2

* Added support for `channels.createMessage`.
* Added support for `users.getCurrentUser`.
* Fixed a bug where JSON payloads did not have the right `Content-Type`.
* Added the `User` and `Message` structures.

## 0.1.0-alpha+1

* Small change to `REAMDE.md`.

## 0.1.0-alpha

* Initial release, mostly as a proof-of-concept only. See `README.md`.
