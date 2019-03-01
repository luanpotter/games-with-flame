import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/resizable.dart';

const S = 1.2;

class Player extends AnimationComponent {
  Player() : super.sequenced(S * 48, S * 37, 'plane.png', 4, textureWidth: 48);

  @override
  void resize(Size size) {
    x = (size.width - width) / 2;
    y = size.height - height - 10;
  }
}

class Background extends Component with Resizable {

  Sprite sprite = Sprite('clouds.png');
  Position p = Position.empty();

  double get width => 6.0 * 128;
  double get height => 6.0 * 128;
  Position get imageSize => Position(width, height);

  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Color(0xff639bff));
    sprite.renderPosition(c, p, imageSize);
    sprite.renderPosition(c, Position(p.x, p.y - height), imageSize);
    sprite.renderPosition(c, Position(p.x - width, p.y), imageSize);
    sprite.renderPosition(c, Position(p.x - width, p.y - height), imageSize);
  }

  @override
  void update(double t) {
    p.x += 10 * t;
    p.y += 12 * t;
  }

  @override
  int priority() => -1;
}

class MyGame extends BaseGame {

  MyGame() {
    add(Player());
    add(Background());
  }
}