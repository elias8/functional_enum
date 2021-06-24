[![Build Status](https://travis-ci.org/Elias8/functional_enum.svg?branch=master)](https://travis-ci.org/Elias8/functional_enum)
[![pub package](https://img.shields.io/pub/v/functional_enum.svg)](https://pub.dartlang.org/packages/functional_enum)

# Functional Enum
_Freezed, but for enums._

Code generator for functional enum that makes the use of enums much better.

## Usage

```dart
import 'package:functional_enum_annotation/functional_enum_annotation.dart';

part 'main.g.dart';

@functionalEnum
enum Shape { square, circle, triangle }

void main() {
  final shape = Shape.circle;

  // all cases must be handled
  final message = shape.when(
    square: () => 'I am a Square',
    circle: () => 'I am a Circle',
    triangle: () => 'I am a Triangle',
  );
  print(message); // I am a Circle

  // all cases may not be handled but `orElse` cannot be null
  final canBeRotated = shape.maybeWhen(
    circle: () => false,
    orElse: () => true,
  );
  print(canBeRotated); // false

  // equivalent to print(shape == Shape.circle)
  print(shape.isCircle); // true
  print(shape.isSquare); // false
  print(shape.isTriangle); // false
}
```

With flutter:

```dart
@functionalEnum
enum AppState { initial, loading, loaded }

class ExampleWidget extends StatelessWidget {
  final Appstate appState;

  const ExampleWidget({Key key, this.appState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appState.when(
      initial: () => SizedBox(),
      loading: () => CircularProgressIndicator(),
      loaded: () => HomePage(),
    );
  }
}
```