// Copyright 2017, Matan Lurey.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
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
    return new File((b) => b
      ..body.addAll([
        _generateBuilder(element),
        _generateModel(element),
      ])).accept(const DartEmitter()).toString();
  }

  static const _$DateTime = const TypeChecker.fromRuntime(DateTime);
  static const _$Structure = const TypeChecker.fromRuntime(meta.Structure);
  static const _$Field = const TypeChecker.fromRuntime(meta.Field);

  static Class _generateBuilder(ClassElement clazz) => new Class((b) => b
    ..name = '_\$${clazz.name}Builder'
    ..fields.addAll(clazz.accessors.map((a) => new Field((b) => b
      ..name = a.name
      ..type = new Reference(a.returnType.displayName))))
    ..methods.add(new Method((b) => b
      ..name = '_build'
      ..returns = new Reference('_\$${clazz.name}')
      ..body = new Code((b) => b
        ..code = '''return new _\$${clazz.name}._internal(
          ${clazz.accessors.map((a) => '${a.name}: ${a.name}').join(', ')},
        );'''))));

  static Class _generateModel(ClassElement clazz) => new Class((b) => b
    ..name = '_\$${clazz.name}'
    ..implements.add(new Reference(clazz.name))
    ..fields.addAll(clazz.accessors.map((a) => new Field((b) => b
      ..name = a.name
      ..annotations.add(new Annotation(
          (b) => b..code = new Code((b) => b..code = 'override')))
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
        ..body = new Code((b) => b..code = 'return null;')
        ..requiredParameters.add(new Parameter(
          (b) => b..name = 'void build(_\$${clazz.name}Builder builder)',
        ))
        ..body = new Code((b) => b
          ..code = '''
            final builder = new _\$${clazz.name}Builder();
            build(builder);
            return builder._build();
          ''')),
      new Constructor((b) => b
        ..factory = true
        ..name = 'fromJson'
        ..lambda = true
        ..body = new Code((b) => b
          ..code = '''
          (new _\$${clazz.name}Builder()
          ${clazz.accessors.map((a) {
            final metadata = _$Field.firstAnnotationOfExact(a);
            final reader = new ConstantReader(metadata);
            final name = reader.read('name').stringValue;
            final element = a.returnType.element;
            final display = a.returnType.displayName;
            if (element is ClassElement) {
              if (element.isEnum) {
                return '..${a.name} = $display.values[json[\'$name\'] as int]';
              } else if (_$Structure.hasAnnotationOfExact(element)) {
                return '..${a.name} = new $display.fromJson(json[\'$name\'] as Map<String, Object>)';
              } else if (_$DateTime.isExactlyType(a.returnType)) {
                return '..${a.name} = DateTime.parse(json[\'$name\'] as String)';
              } else if (element.type.isObject) {
                return '..${a.name} = json[\'$name\']';
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
