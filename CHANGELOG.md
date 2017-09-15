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
