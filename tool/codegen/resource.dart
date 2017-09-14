// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart' hide Resource;
import 'package:code_builder/code_builder.dart';
import 'package:din/src/schema/metadata.dart' as meta;
import 'package:source_gen/source_gen.dart';

/// Generates a `<file>.g.dart` that implements `_$Class` for `@Resource()`.
class ResourceGenerator extends GeneratorForAnnotation<meta.Resource> {
  const ResourceGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    covariant ClassElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final urlRoot = annotation.read('root').stringValue;
    return new Class((b) {
      _writeClassDefaults(b, element);
      _implementEndpoints(b, urlRoot, element);
    }).accept(const DartEmitter()).toString();
  }

  static void _writeClassDefaults(ClassBuilder b, ClassElement clazz) => b
    ..name = '_\$${clazz.name}'
    ..implements.add(new Reference(clazz.name))
    ..fields.add(new Field((b) => b
      ..name = '_restClient'
      ..type = const Reference('RestClient')
      ..modifier = FieldModifier.final$))
    ..constructors.add(new Constructor((b) => b
      ..requiredParameters.add(new Parameter((b) => b
        ..name = '_restClient'
        ..toThis = true))));

  static const _$Endpoint = const TypeChecker.fromRuntime(meta.Endpoint);

  static void _implementEndpoints(
    ClassBuilder b,
    String urlRoot,
    ClassElement element,
  ) {
    for (final method in element.methods) {
      if (_$Endpoint.hasAnnotationOfExact(method)) {
        b.methods.add(_generateEndpoint(
          urlRoot,
          new ConstantReader(_$Endpoint.firstAnnotationOfExact(method)),
          method,
        ));
      }
    }
  }

  static Method _generateEndpoint(
    String urlRoot,
    ConstantReader endPoint,
    MethodElement method,
  ) =>
      new Method((b) => b
        ..annotations.add(new Annotation(
            (b) => b..code = new Code((b) => b..code = 'override')))
        ..name = method.name
        ..returns = new Reference(method.returnType.displayName)
        ..optionalParameters
            .addAll(method.parameters.map((m) => new Parameter((b) => b
              ..name = m.name
              ..named = true
              ..type = new Reference(m.type.displayName))))
        ..body = new Code((b) => b
          ..code = '''
          return _restClient.request(
            url: '${_getUrl(urlRoot, endPoint.read('path').listValue)}',
            method: '${endPoint.read('method').stringValue}',
          ).then((json) => new ${_getStructureName(method.returnType)}.fromJson(json));
        '''));

  static String _getUrl(String root, List<DartObject> path) =>
      ([root]..addAll(path.map((o) {
              final reader = new ConstantReader(o);
              if (reader.isString) {
                return reader.stringValue;
              }
              if (reader.isSymbol) {
                return '\$${reader.objectValue.toSymbolValue()}';
              }
              throw new UnsupportedError('Invalid type: ${reader.objectValue}');
            })))
          .join('/');

  static String _getStructureName(DartType type) {
    if (type is ParameterizedType) {
      return type.typeArguments.first.displayName;
    }
    return type.displayName;
  }
}
