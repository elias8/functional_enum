library functional_enum;

import 'package:build/build.dart';
import 'package:functional_enum/src/functional_enum_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder functionalEnum(BuilderOptions options) {
  return PartBuilder([FunctionalEnumGenerator()], '.g.dart');
}
