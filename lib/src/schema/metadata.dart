// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Metadata annotations that are processed offline by `tool/generators/*.dart`.
///
/// The Discord API is provided as an HTML web page without precise structure
/// that is efficient and safe to generate API scaffolding from, so instead the
/// API is triaged into metadata annotations.
///
/// [Full API documentation](https://discordapp.com/developers/docs/reference).
library din.src.schema.metadata;

import 'package:meta/meta.dart';

/// Annotates a specific resource type provided by the Discord API.
///
/// Example use:
/// ```dart
/// part 'channels.g.dart';
///
/// @Resource(
///   root: 'channels',
///   docs: 'https://discordapp.com/developers/docs/resources/channel',
/// )
/// abstract class ChannelsResource {
///   factory ChannelsResource() = _$ChannelsResource;
/// }
/// ```
class Resource {
  /// Root URL segment for the resource, such as `channels`.
  final String root;

  /// URL for the documentation for this resource.
  final String docs;

  const Resource({
    @required this.root,
    @required this.docs,
  });
}

/// Annotates a method that should invoke a REST endpoint on the API.
class Endpoint {
  /// URL for the documentation for this endpoint.
  final String docs;

  /// HTTP method to invoke.
  ///
  /// A special type of `'PUT/PATCH'` may be used to indicate that omitting a
  /// parameter should use `'PATCH'`, while specifying all parameters should use
  /// `'PUT'`.
  final String method;

  /// Path to use when generating the final URL.
  ///
  /// An element of `String` type means a static value, while `Symbol` means
  /// to use a parameter of the annotated method. For example:
  /// ```dart
  /// abstract class ChannelsResource {
  ///   @Endpoint(
  ///     method: 'GET',
  ///     path: const [#id, 'messages'],
  ///   )
  ///   Future<Channel> getChannelMessages({
  ///     @required String id,
  ///   });
  /// }
  /// ```
  ///
  /// Any parameter _not_ in `path` is considered to be a _query string_
  /// parameter, _unless_ [Endpoint.asJson] is used instead, in which case the
  /// parameters create a JSON blob.
  final List<Object> path;

  /// Set to `true` if the [Endpoint.asJson] constructor is used.
  ///
  /// In this case, unused parameters represent a JSON blob.
  final bool unusedParametersAreJson;

  const Endpoint({
    @required this.docs,
    @required this.method,
    @required this.path,
  })
      : unusedParametersAreJson = false;

  const Endpoint.asJson({
    @required this.docs,
    @required this.method,
    @required this.path,
  })
      : unusedParametersAreJson = true;
}

/// Annotates a JSON structured object that is sent or received to the API.
///
/// Example use:
/// ```dart
/// part 'message.g.dart';
///
/// @Structure(
///   docs: 'https://discordapp.com/developers/docs/resources/channel#message-object',
/// )
/// abstract class Messages {
///   factory Messages() = _$Messages;
/// }
/// ```
class Structure {
  /// URL for the documentation for this structure.
  final String docs;

  const Structure({
    @required this.docs,
  });
}

/// Annotates a field of a JSON [Structure].
///
/// Example use:
/// ```dart
/// part 'message.g.dart';
///
/// @Structure(
///   docs: 'https://discordapp.com/developers/docs/resources/channel#message-object',
/// )
/// abstract class Messages {
///   factory Messages() = _$Messages;
///
///   @Field(
///     name: 'content',
///   )
///   String get content;
/// }
/// ```
class Field {
  /// Name of the field in JSON.
  final String name;

  /// Whether the field is nullable.
  ///
  /// By default this is `false`.
  final bool nullable;

  /// Type of the field.
  ///
  /// This is only required when it does not represent either a JSON primitive
  /// _or_ an existing [Structure] - for example, for timestamps or snowflakes -
  /// otherwise if omitted field type is inferred from Dart type annotations.
  final FieldType type;

  const Field({
    @required this.name,
    this.nullable: false,
    this.type,
  });
}

/// Types of [Field].
///
/// May be omitted (i.e. `null`) to mean infer from type annotation.
enum FieldType {
  timestamp,
  snowflake,
}
