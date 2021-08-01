[![Build Status](https://travis-ci.org/Elias8/functional_enum.svg?branch=master)](https://travis-ci.org/Elias8/functional_enum)
[![pub package](https://img.shields.io/pub/v/functional_enum.svg)](https://pub.dartlang.org/packages/functional_enum)

# Functional Enum
_[Freezed](https://pub.dev/packages/freezed), but for enums._

Code generator for functional enum that makes the use of enums much better.

## Installation

Add the following dependencies to your project.

```yaml
dependencies:
  functional_enum_annotation: 
    
dev_dependencies:
  build_runner:
  functional_enum: 
```

## Usage

#### With pure dart

```dart
import 'package:functional_enum_annotation/functional_enum_annotation.dart';

// assuming your file name is main.dart
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

#### With flutter

```dart
import 'package:functional_enum_annotation/functional_enum_annotation.dart';

// assuming your file name is main.dart
part 'main.g.dart';

@functionalEnum
enum AppState { initial, loading, loaded }

class MyWidget extends StatelessWidget {
  final Appstate appState;

  const MyWidget({Key key, this.appState}) : super(key: key);

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

## Generate the code

Once you have completed the above steps, you should run the [build_runner](https://pub.dev/packages/build_runner) to generate the code for you.
You can use the following commands to run the code generator:

- For dart projects use
```shell
$ dart pub run build_runner build
```
- and for flutter projects use
```shell
$ flutter pub run build_runner build
```

## Maintainers
- [Elias Andualem](https://github.com/elias8)