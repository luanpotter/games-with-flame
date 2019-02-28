import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game.dart';

void main() async {
  await Flame.util.fullScreen();
  await Flame.util.setOrientation(DeviceOrientation.portraitUp);
  await Flame.images.loadAll(['plane.png', 'plane-2.png', 'clouds.png', 'bullet-2.png', 'explosion.png']);

  MyGame game = MyGame();
  runApp(game.widget);

  Flame.util.addGestureRecognizer(MultiTapGestureRecognizer()
    ..onTapDown = (int pointer, TapDownDetails details) {
      Position p = Position.fromOffset(details.globalPosition);
      game.tapDown(p);
    }
    ..onTapUp = (int pointer, TapUpDetails details) {
      game.tapUp();
    });
  Flame.util.addGestureRecognizer(ImmediateMultiDragGestureRecognizer()
    ..onStart = (Offset position) => MyDrag(game));
}

class MyDrag extends Drag {
  MyGame game;

  MyDrag(this.game);

  @override
  void end(DragEndDetails details) {
    game.tapUp();
  }
}
