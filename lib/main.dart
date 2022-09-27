import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:lukas_fyi/rectangle_spinner.dart';

void main() {
  runApp(GameWidget(game: LukasGame()));
}

class LukasGame extends FlameGame with MouseMovementDetector, TapDetector {
  final world = World();
  late final CameraComponent cameraComponent;

  @override
  Future<void> onLoad() async {
    world.children.register<RectangleSpinner>();
    cameraComponent = CameraComponent(
      world: world,
      viewfinder: Viewfinder()
        ..anchor = Anchor.center
        ..position = size / 2,
    );
    addAll([world, cameraComponent]);
  }

  @override
  void onTapUp(TapUpInfo info) {
    world.add(RectangleSpinner(position: info.eventPosition.game, size: size));
    //for (final spinner in world.children.query<RectangleSpinner>()) {
    //  spinner.startEffect();
    //}
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    //final eventPosition = info.eventPosition.viewport;
    //cameraComponent.viewfinder.position = info.eventPosition.viewport;
    //cameraComponent.viewfinder.anchor =
    //    Anchor(eventPosition.x / size.x, eventPosition.y / size.y);
  }
}
