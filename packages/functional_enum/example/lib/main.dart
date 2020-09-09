import 'package:functional_enum_annotation/functional_enum_annotation.dart';

part 'main.g.dart';

@functional_enum
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
