import 'package:analyzer/dart/element/element.dart';
import 'package:meta/meta.dart';

class EnumExtensionGenerator {
  final ClassElement element;
  final _generated = StringBuffer();

  EnumExtensionGenerator(this.element)
      : assert(element.kind == ElementKind.ENUM);

  String generate() {
    _generateExtensionHeader();
    _generateCheckers();
    _generateMethods();
    _generateExtensionBottom();
    return _generated.toString();
  }

  void _generateExtensionBottom() => _generated.writeln('}');

  void _generateExtensionHeader() {
    _generated
        .writeln('extension ${element.name}Extension on ${element.name}{');
  }

  void _generateMethods() {
    final methodGenerator = MethodGenerator(element: element);
    _generated.writeln(methodGenerator.generate(MethodType.map));
    _generated.writeln(methodGenerator.generate(MethodType.maybeMap));
    _generated.writeln(methodGenerator.generate(MethodType.maybeWhen));
    _generated.writeln(methodGenerator.generate(MethodType.when));
  }

  void _generateCheckers() => element.fields.skip(2).forEach(_generateChecker);

  void _generateChecker(FieldElement e) {
    var name = e.name;
    name = name.replaceRange(0, 1, name[0].toUpperCase());
    final field = 'bool get is$name => this == ${element.name}.${e.name};';
    _generated.writeln(field);
  }
}

class MethodGenerator {
  final ClassElement element;
  final List<FieldElement> values;
  final _generated = StringBuffer();
  bool _shouldAddArgs;
  bool _isRequiredType;
  MethodType _methodType;

  MethodGenerator({@required this.element})
      : values = element.fields.skip(2).toList();

  String generate(MethodType type) {
    _initialize(type);
    _ignoreReturnTypeWarnings();
    _addReturnTypeAndName();
    _addParams();
    _addAssertions();
    _addHandlers();
    return _generated.toString();
  }

  void _addAssertions() {
    _generated.writeln('{');
    values.forEach(_assertField);
    if (!_isRequiredType) _generated.write('assert(orElse != null);');
  }

  void _addHandler(FieldElement e) {
    final name = e.name;
    final notNull = _isRequiredType ? '' : '&& $name != null';
    final condition = 'if(this == ${element.name}.$name $notNull)';
    final returnValue = 'return $name(${_shouldAddArgs ? 'this' : ''});';
    _generated.writeln('$condition $returnValue');
  }

  void _addHandlers() {
    values.forEach(_addHandler);
    if (!_isRequiredType) _generated.write('return orElse();');
    _generated.writeln('}');
  }

  void _addParam(FieldElement e) {
    final name = e.name;
    final required = _isRequiredType ? '@required' : '';
    final args = '${_shouldAddArgs ? '${element.name} $name' : ''}';
    final returnType = 'R Function($args)';
    _generated.writeln('$required $returnType ${e.name},');
  }

  void _addParams() {
    _generated.writeln('({');
    values.forEach(_addParam);
    if (!_isRequiredType) _generated.writeln('@required R Function() orElse,');
    _generated.writeln('})');
  }

  void _addReturnTypeAndName() => _generated.write('R ${_methodName()}<R>');

  void _assertField(FieldElement element) {
    if (_isRequiredType) _generated.writeln('assert(${element.name} != null);');
  }

  void _ignoreReturnTypeWarnings() {
    if (_methodType == MethodType.when || _methodType == MethodType.map) {
      _generated.writeln('// ignore: missing_return');
    }
  }

  void _initialize(MethodType methodType) {
    _generated.clear();
    _methodType = methodType;
    _isRequiredType =
        methodType == MethodType.when || methodType == MethodType.map;
    _shouldAddArgs =
        methodType == MethodType.map || methodType == MethodType.maybeMap;
  }

  String _methodName() {
    switch (_methodType) {
      case MethodType.map:
        return 'map';
      case MethodType.maybeMap:
        return 'maybeMap';
      case MethodType.maybeWhen:
        return 'maybeWhen';
      case MethodType.when:
        return 'when';
    }
    return '';
  }
}

enum MethodType { map, maybeMap, maybeWhen, when }
