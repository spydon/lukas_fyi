import 'dart:math';

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

  @override
  Future<void> onLoad() async {
    children.register<RectangleComponent>();
    final amount = (min(size.x, size.y) / 30).floor();
    var lastSize = size.clone();
    final rectangles = List.generate(200, (i) {
      lastSize = lastSize / 2;
      return RectangleComponent(
        position: size / 2, // - Vector2.all(i * 5),
        //size: Vector2.all(i * 2.0 + (i * i * i) / 2),
        //size: Vector2.all(100) + lastSize,
        size: Vector2.all(10) * i.toDouble(),
        anchor: Anchor.center,
        paint: Paint()
          ..color = (Colors.red.brighten(i / 200))
          ..style = PaintingStyle.stroke,
      );
    });
    addAll(rectangles);
  }

  void startEffect() {
    children.query<RectangleComponent>().forEachIndexed((i, rectangle) {
      rectangle.addAll([
        RotateEffect.by(
          6 * tau,
          EffectController(
            duration: 6 * 6,
            startDelay: i * 0.1,
            infinite: true,
            alternate: true,
          ),
        ),
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
