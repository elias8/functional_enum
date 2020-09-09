import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:functional_enum_annotation/functional_enum_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'enum_generator.dart';

class FunctionalEnumGenerator extends GeneratorForAnnotation<FunctionalEnum> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind == ElementKind.ENUM && element is ClassElement) {
      return EnumExtensionGenerator(element).generate();
    } else {
      throw InvalidGenerationSourceError(
        '''@functional_enum can only be applied on enum types. Instead, you are trying to use is it on a ${element.kind} ${element.name}.''',
        element: element,
      );
    }
  }
}
