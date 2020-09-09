// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// FunctionalEnumGenerator
// **************************************************************************

extension ShapeExtension on Shape {
  bool get isSquare => this == Shape.square;
  bool get isCircle => this == Shape.circle;
  bool get isTriangle => this == Shape.triangle;
// ignore: missing_return
  R map<R>({
    @required R Function(Shape square) square,
    @required R Function(Shape circle) circle,
    @required R Function(Shape triangle) triangle,
  }) {
    assert(square != null);
    assert(circle != null);
    assert(triangle != null);
    if (this == Shape.square) return square(this);
    if (this == Shape.circle) return circle(this);
    if (this == Shape.triangle) return triangle(this);
  }

  R maybeMap<R>({
    R Function(Shape square) square,
    R Function(Shape circle) circle,
    R Function(Shape triangle) triangle,
    @required R Function() orElse,
  }) {
    assert(orElse != null);
    if (this == Shape.square && square != null) return square(this);
    if (this == Shape.circle && circle != null) return circle(this);
    if (this == Shape.triangle && triangle != null) return triangle(this);
    return orElse();
  }

  R maybeWhen<R>({
    R Function() square,
    R Function() circle,
    R Function() triangle,
    @required R Function() orElse,
  }) {
    assert(orElse != null);
    if (this == Shape.square && square != null) return square();
    if (this == Shape.circle && circle != null) return circle();
    if (this == Shape.triangle && triangle != null) return triangle();
    return orElse();
  }

// ignore: missing_return
  R when<R>({
    @required R Function() square,
    @required R Function() circle,
    @required R Function() triangle,
  }) {
    assert(square != null);
    assert(circle != null);
    assert(triangle != null);
    if (this == Shape.square) return square();
    if (this == Shape.circle) return circle();
    if (this == Shape.triangle) return triangle();
  }
}
