<p align="center">
  <h1 align="center">din</h1>
  <p align="center">
    An <em>unofficial</em> Dart library for <a href="https://discordapp.com/developers">Discord</a>.
  </p>
</p>

[![Uses Dart 1.25.0-dev](https://img.shields.io/badge/dart-%3E%3D1.25.0-blue.svg)](https://www.dartlang.org/install/archive#dev-channel)
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Pub Package](https://img.shields.io/pub/v/din.svg)](https://pub.dartlang.org/packages/din)
[![Build Status](https://travis-ci.org/matanlurey/din.svg)](https://travis-ci.org/matanlurey/din)

[![GitHub Issues](https://img.shields.io/github/issues/matanlurey/din.svg)](https://github.com/matanlurey/din/issues)
[![GitHub Forks](https://img.shields.io/github/stars/matanlurey/din.svg)](https://github.com/matanlurey/din/forks)
[![GitHub Stars](https://img.shields.io/github/stars/matanlurey/din.svg)](https://github.com/matanlurey/din/stars)


* [Install](#install)
* [Usage](#usage)
* [Contributing](#contributing)
  * [Testing](#testing)

## Install

The current pre-release of `din` does not require other runtime dependencies.

```yaml
dependencies:
  din: ^0.1.0-alpha+5
```

To get started, it's recommended to read the
[Discord documentation](https://discordapp.com/developers) and
[create an application](https://discordapp.com/developers/applications/me) for
API access.

## Usage

It's recommended to import `din` prefixed whenever possible:

```dart
import 'package:din/din.dart' as din;
```

### Platforms

Currently this library is **only supported** on the standalone VM and Flutter,
but can be easily expanded by implementing a custom `HttpClient`. See the VM
implementation at `lib/platform/vm.dart` for an example. You can then pass the
client in:

```dart
void main() {
  final client = const din.ApiClient(
    rest: const din.RestClient(
      auth: const din.AuthScheme.asBot('YOUR_TOKEN_HERE'),
      http: const CustomHttpClient(),
    ),
  );
}

class CustomHttpClient implements din.HttpClient { /* TODO: Implement. */ }
```

## Contributing

### Discord API Changes

As [explained below](#api), the REST API endpoints for Discord are manually
specified but much/almost all of the boilerplate code around JSON encoding and
generating URLs is handled by offline code generation, and published as part of
this package.

Implementation:
* `tool/codegen/resource.dart`
* `tool/codegen/structure.dart`

The current implementation is fairly ad-hoc, and does not yet support all the
different use-cases in the Discord API. That is also OK; the API is flexible in
that some of the methods can be implemented by hand if needed, and the others
are generated.

If you make a change to anything in `lib/src/schema/**` or the code generators
re-run the build script at `tool/build.dart` to update `<file>.g.dart` files:

```sh
$ dart tool/build.dart
```

Or, leave a watcher open to automatically rebuild:

```sh
$ dart tool/build.dart --watch
```

### Testing

The easiest way to run all the unit tests with the precise configuration needed
is to run `tool/test.dart`. This in turn runs a series of web servers
(as needed) for local testing, and `pub run test` to execute the test cases:

```sh
$ dart tool/test.dart
```

For manual testing, (i.e. running/debugging a specific test):

* Run `tool/servers/static.dart` before running any HTTP client tests:

```sh
$ dart tool/servers/static.dart

...

$ pub run test test/clients/http_client_vm_test.dart
```

#### End-to-end testing

Sometimes when changing the API, or releasing a new version of this library it
is important to verify that the entire end-to-end story still works connected
to the real Discord API server.

Tests in the `e2e/**` folder do this, but are part of `tool/test.dart` in order
to avoid overloading Discord's servers from continuous integration systems like
travis. In order to run manually, or on something like a cron-job, run:

```sh
$ DISCORD_API_TOKEN='1234' DISCORD_CHANNEL_ID='1234' DISCORD_USER_NAME='...' pub run test e2e
```

Note that all variables above must be set as an environment variable to use
these tests. If you do not have one, [login to discord](https://discordapp.com/developers/applications/me)
and create an application. **Do not share** this token with others, it should
remain private. Make sure to add access for your bot to connect and interact
with the channel specified by `DISCORD_CHANNEL_ID`.

You may optionally add a `config.yaml` file to `e2e/config.yaml` instead; it
is ignored by `.gitignore` and is for convenience while developing locally.

```yaml
api_token:  "..."
channel_id: "..."
user_name:  "..."
```

## Design

The `din` package is built to be layered, customizable, and easily hackable,
both for direct contributors to the package, and for packages built on top of
`din`. There are three "tiers" of APIs available, each with high-level
functionality:

### HTTP

Din provides a minimal, platform-independent HTTP interface, or `HttpClient`:

```dart
abstract class HttpClient {
  /// Sends an HTTP request to [path] using [method].
  ///
  /// May optionally define a [payload] and HTTP [headers].
  ///
  /// Unlike a standard [Future], a [CancelableOperation] may be cancelled if
  /// the in-flight request is no longer valid or wanted. In that event, the
  /// [CancelableOperation.value] may never complete.
  CancelableOperation<Map<String, Object>> requestJson(
    String path, {
    String method: 'GET',
    Map<String, Object> payload,
    Map<String, String> headers,
  });
}
```

While this itself is not _that_ useful for building a bot or application, it
does provide a very simple way to create custom HTTP implementations, such as
those that do caching, offline support, or work on a variety of platforms. The
built-in/default implementation works on the standalone Dart VM and Flutter.

### REST

The official [Discord API](https://discordapp.com/developers/docs/reference) is
REST-based, and requires a series of HTTP headers in order to communicate. This
is encapsulated as `RestClient`, which in turn can make an HTTP request to any
given REST endpoint. It does not have knowledge of the precise endpoints of
the Discord API, though, and only communicates in raw/untyped JSON.

Creating one is required to use `ApiClient`, the highest-level API provided:

```dart
final rest = const din.RestClient(
  auth: const din.AuthScheme.asBot('YOUR_TOKEN_HERE'),
);
```

For clients or libraries that do not want to use `ApiClient`, they can use
`RestClient` in order to remove much of the boiler-plate around how to connect
and utilize the REST API.

### API

A semi-automatically updated high-level API for communicating with precise REST
endpoints in the Discord API used strongly-typed methods, returning strongly
typed Dart objects. There is no official schema provided by the Discord team,
so instead the schema is hand-maintained as metadata annotations, and the exact
API is generated from that.

See `tool/build.dart`, and `lib/src/schema/**` for more information.
