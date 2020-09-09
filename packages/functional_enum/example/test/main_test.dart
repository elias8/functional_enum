import 'package:example/main.dart';
import 'package:test/test.dart';

void main() {
  const circleText = 'This is Circle';
  const squareText = 'This is Square';
  const triangleText = 'This is Triangle';

  const circle = Shape.circle;
  const square = Shape.square;
  const triangle = Shape.triangle;

  String when(Shape shape) {
    return shape.when(
      square: () => squareText,
      circle: () => circleText,
      triangle: () => triangleText,
    );
  }

  test('should generated condition return expected result', () {
    expect(circle.isCircle, isTrue);
    expect(square.isSquare, isTrue);
    expect(triangle.isTriangle, isTrue);
  });

  test('should when method return the correct value', () {
    expect(when(square), squareText);
    expect(when(circle), circleText);
    expect(when(triangle), triangleText);
  });

  test('should mayBeWhen method return orElse-s value when case is not handled',
      () {
    final shape = Shape.circle;

    final result = shape.maybeWhen(orElse: () => true);

    expect(result, isTrue);
  });

  test(
      'should mayBeWhen method return orElse-s value when case is handled and condition is not met',
      () {
    final shape = Shape.square;

    final result = shape.maybeWhen(circle: () => true, orElse: () => false);

    expect(result, isFalse);
  });

  test(
      'should mayBeWhen method return expected result when case is handled and condition is met',
      () {
    final shape = Shape.circle;

    final result = shape.maybeWhen(circle: () => true, orElse: () => false);

    expect(result, isTrue);
  });
}
