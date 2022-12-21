import 'package:analyzer/dart/element/element.dart';

class EnumExtensionGenerator {
  final EnumElement element;
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

  void _generateChecker(FieldElement e) {
    var name = e.name;
    name = name.replaceRange(0, 1, name[0].toUpperCase());
    final field = 'bool get is$name => this == ${element.name}.${e.name};';
    _generated.writeln(field);
  }

  void _generateCheckers() {
    element.fields
        .where((element) => element.isEnumConstant)
        .forEach(_generateChecker);
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
}

class MethodGenerator {
  final EnumElement element;
  final List<FieldElement> values;
  final _generated = StringBuffer();
  late MethodType _methodType;

  MethodGenerator({required this.element})
      : values =
            element.fields.where((element) => element.isEnumConstant).toList();

  String generate(MethodType type) {
    _initialize(type);
    _addReturnTypeAndName();
    _addParameters();
    _addRequiredParamHandler();
    _addOptionalParamHandler();
    return _generated.toString();
  }

  void _addOptionalParamHandler() {
    if (!_isParamRequired()) {
      _generated.writeln('{');
      for (int i = 0; i < values.length; i++) {
        final name = values[i].name;
        final enumType = '${element.name}.$name';
        final ifCondition = 'if(this == $enumType && $name != null)';
        final condition = i == 0 ? ifCondition : 'else $ifCondition';
        _generated.writeln(condition);
        _generated.writeln('{ ${_getReturnStatement(name)} }');
      }
      _generated.writeln('else { return orElse(); }');
      _generated.writeln('}');
    }
  }

  void _addOrElseCallBack() {
    if (!_isParamRequired()) {
      _generated.writeln('required R Function() orElse,');
    }
  }

  void _addParam(FieldElement field) {
    final name = field.name;
    final nullable = _isParamRequired() ? '' : '?';
    final required = _isParamRequired() ? 'required' : '';
    final returnType = 'R Function(${_getCallBackArg(name)})';
    _generated.writeln('$required $returnType$nullable ${field.name},');
  }

  void _addParameters() {
    _generated.writeln('({');
    values.forEach(_addParam);
    _addOrElseCallBack();
    _generated.writeln('})');
  }

  void _addRequiredParamHandler() {
    if (_isParamRequired()) {
      _generated.writeln('{');
      _generated.writeln('switch(this) {');
      values.forEach(_addSwitchCase);
      _generated.writeln('}');
      _generated.writeln('}');
    }
  }

  void _addReturnTypeAndName() => _generated.write('R ${_methodName()}<R>');

  void _addSwitchCase(FieldElement field) {
    final name = field.name;
    final condition = 'case ${element.name}.$name: ';
    final returnValue = _getReturnStatement(name);
    _generated.writeln('$condition $returnValue');
  }

  String _getCallBackArg(String callBackName) {
    return '${_shouldAddArgs() ? '${element.name} $callBackName' : ''}';
  }

  String _getReturnStatement(String callbackName) {
    return 'return $callbackName(${_shouldAddArgs() ? 'this' : ''});';
  }

  void _initialize(MethodType methodType) {
    _generated.clear();
    _methodType = methodType;
  }

  bool _isParamRequired() {
    return _methodType == MethodType.when || _methodType == MethodType.map;
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
  }

  bool _shouldAddArgs() {
    return _methodType == MethodType.map || _methodType == MethodType.maybeMap;
  }
}

enum MethodType { map, maybeMap, maybeWhen, when }
