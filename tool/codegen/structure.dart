// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart' hide Resource;
import 'package:code_builder/code_builder.dart';
import 'package:din/src/schema/metadata.dart' as meta;
import 'package:source_gen/source_gen.dart';

/// Generates a `<file>.g.dart` that implements `_$Class` for `@Structure()`.
class StructureGenerator extends GeneratorForAnnotation<meta.Structure> {
  const StructureGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    covariant ClassElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    return new Library((b) => b
      ..body.addAll([
        _generateBuilder(element),
        _generateModel(element),
      ])).accept(new DartEmitter.scoped()).toString();
  }

  static const _$override = const Reference('override', 'dart:core');
  static const _$DateTime = const TypeChecker.fromRuntime(DateTime);
  static const _$Structure = const TypeChecker.fromRuntime(meta.Structure);
  static const _$Field = const TypeChecker.fromRuntime(meta.Field);
  static const _$List = const TypeChecker.fromRuntime(List);

  static Class _generateBuilder(ClassElement clazz) => new Class((b) => b
    ..name = '_\$${clazz.name}Builder'
    ..fields.addAll(clazz.accessors.map((a) => new Field((b) => b
      ..name = a.name
      ..type = new Reference(a.returnType.displayName))))
    ..methods.add(new Method((b) => b
      ..name = '_build'
      ..returns = new Reference('_\$${clazz.name}')
      ..body = new Code.scope((_) => '''return new _\$${clazz.name}._internal(
          ${clazz.accessors.map((a) => '${a.name}: ${a.name}').join(', ')},
        );'''))));

  static Class _generateModel(ClassElement clazz) => new Class((b) => b
    ..name = '_\$${clazz.name}'
    ..implements.add(new Reference(clazz.name))
    ..fields.addAll(clazz.accessors.map((a) => new Field((b) => b
      ..name = a.name
      ..annotations
          .add(new Annotation((b) => b..code = _$override.annotation().code))
      ..type = new Reference(a.returnType.displayName)
      ..modifier = FieldModifier.final$)))
    ..constructors.addAll([
      new Constructor((b) => b
        ..name = '_internal'
        ..constant = true
        ..optionalParameters
            .addAll(clazz.accessors.map((a) => new Parameter((b) => b
              ..name = a.name
              ..named = true
              ..toThis = true)))),
      new Constructor((b) => b
        ..factory = true
        ..body = const Code('return null;')
        ..requiredParameters.add(new Parameter(
          (b) => b..name = 'void build(_\$${clazz.name}Builder builder)',
        ))
        ..body = new Code.scope((_) => '''
            final builder = new _\$${clazz.name}Builder();
            build(builder);
            return builder._build();
          ''')),
      new Constructor((b) => b
        ..factory = true
        ..name = 'fromJson'
        ..lambda = true
        ..body = new Code.scope((_) => '''
          json == null ? null : (new _\$${clazz.name}Builder()
          ${clazz.accessors.map((a) {
            final metadata = _$Field.firstAnnotationOfExact(a);
            final reader = new ConstantReader(metadata);
            final name = reader.read('name').stringValue;
            final element = a.returnType.element;
            final display = a.returnType.displayName;
            if (element is ClassElement) {
              if (element.isEnum) {
                return '..${a.name} = json.containsKey(\'$name\') ?  $display.values[json[\'$name\'] as int]: null';
              } else if (_$Structure.hasAnnotationOfExact(element)) {
                return '..${a.name} = new $display.fromJson(json[\'$name\'] as Map<String, Object>)';
              } else if (_$DateTime.isExactlyType(a.returnType)) {
                return '..${a.name} = json.containsKey(\'$name\') ? DateTime.parse(json[\'$name\'] as String) : null';
              } else if (element.type.isObject) {
                return '..${a.name} = json[\'$name\']';
              } else if (_$List.isExactly(element) && a.returnType is ParameterizedType) {
                final paramElement = (a.returnType as ParameterizedType).typeArguments.first.element;
                if (_$Structure.hasAnnotationOfExact(paramElement)) {
                  return '..${a.name} = (json.containsKey(\'$name\') ? json[\'$name\'] as List<Map<String, Object>> : const <Map<String, Object>>[]).map((e) => new ${paramElement.name}.fromJson(e)).toList()';
                }
              }
            }
            return '..${a.name} = json[\'$name\'] as $display';
          }).join('\n')}
          )._build()
        ''')
        ..requiredParameters.add(new Parameter((b) => b
          ..name = 'json'
          ..type = const Reference('Map<String, Object>')))),
    ]));
}
