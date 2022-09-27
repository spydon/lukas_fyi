import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class RectangleSpinner extends PositionComponent {
  RectangleSpinner({super.position, super.size}) : super(anchor: Anchor.center);

  final colorTween = ColorTween(begin: Colors.red, end: Colors.lightBlue);

  @override
  Future<void> onLoad() async {
    children.register<RectangleComponent>();
    var lastSize = size.clone();
    final rectangles = List.generate(200, (i) {
      lastSize = lastSize / 2;
      return RectangleComponent(
        position: size / 2,
        size: Vector2.all(10) * i.toDouble(),
        anchor: Anchor.center,
        paint: Paint()
          ..color = colorTween.lerp(i / 200)!
          ..style = PaintingStyle.stroke,
      );
    });
    addAll(rectangles);
  }

  void startEffect() {
    children.query<RectangleComponent>().forEachIndexed((i, rectangle) {
      rectangle.addAll([
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
              curve: Curves.linear,
            ),
          ),
      ]);
    });
  }
}
