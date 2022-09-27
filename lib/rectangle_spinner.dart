import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class RectangleSpinner extends PositionComponent {
  RectangleSpinner({super.position, super.size}) : super(anchor: Anchor.center);

  final colorTween = ColorTween(begin: Colors.red, end: Colors.lightBlue);
  final step = 10.0;
  int get amount => (max(size.x, size.y) / step).ceil();

  @override
  Future<void> onLoad() async {
    children.register<RectangleComponent>();
    final rectangles = List.generate(amount, (i) {
      return RectangleComponent(
        position: size / 2,
        size: Vector2.all(step) * i.toDouble(),
        anchor: Anchor.center,
        paint: Paint()
          ..color = colorTween.lerp(i / amount)!
          ..style = PaintingStyle.stroke,
      );
    });
    await addAll(rectangles);
  }

  bool first = true;

  @override
  void update(double dt) {
    if (first) {
      first = false;
      startEffect();
    }
  }

  void startEffect() {
    stepOne();
  }

  void stepOne() {
    children.query<RectangleComponent>().forEachIndexed((i, rectangle) {
      rectangle.addAll([
        if (rectangle.children.whereType<ScaleEffect>().isEmpty)
          ScaleEffect.to(
            Vector2.all(0.2),
            EffectController(
              duration: 2 * 3,
              repeatCount: 3,
              alternate: true,
            ),
          ),
        if (rectangle.children.whereType<RotateEffect>().length < 2)
          RotateEffect.by(
            3 * tau,
            EffectController(
              duration: 3 * 6,
              startDelay: i * 0.1,
              repeatCount: 2,
              alternate: true,
            ),
            onComplete: i == amount - 1 ? stepTwo : null,
          ),
      ]);
    });
  }

  void stepTwo() {
    children.query<RectangleComponent>().forEachIndexed((i, rectangle) {
      rectangle.addAll([
        if (rectangle.children.whereType<RotateEffect>().length < 2)
          RotateEffect.by(
            3 * tau,
            EffectController(
              duration: 3 * 6,
              startDelay: i * 0.1,
              repeatCount: 2,
              alternate: true,
            ),
          ),
        if (rectangle.children.whereType<ScaleEffect>().isEmpty)
          ScaleEffect.to(
            Vector2.all(20.0),
            EffectController(
              duration: 2 * 3,
              repeatCount: 3,
              alternate: true,
            ),
          ),
      ]);
    });
  }
}
