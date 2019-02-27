import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

const S = 1.5;

class Player extends AnimationComponent {
  Player() : super.sequenced(S * 48.0, S * 37.0, 'plane.png', 4, textureWidth: 48.0);

  @override
  resize(Size size) {
    x = (size.width - width) / 2;
    y = size.height - height - 10.0;
  }
}

class Enemy extends AnimationComponent {
  static const SPEED = 40.0;

  Enemy(double x) : super.sequenced(S * 48.0, S * 37.0, 'plane-2.png', 4, textureWidth: 48.0) {
    this.x = x;
    this.y = -height;
  }

  @override
  void prepareCanvas(Canvas canvas) {
    super.prepareCanvas(canvas);
    canvas.translate(width/2, height/2);
    canvas.scale(1.0, -1.0);
    canvas.translate(-width/2, -height/2);
  }

  @override
  void update(double t) {
    super.update(t);
    y += SPEED * t;
  }
}

class MyGame extends BaseGame {
  MyGame() {
    _doInit();
  }

  _doInit() async {
    Size size = await Flame.util.initialDimensions();
    add(Player());
    add(Enemy(3 * size.width / 10));
  }
}