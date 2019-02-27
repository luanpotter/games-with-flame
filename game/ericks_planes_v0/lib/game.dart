import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/resizable.dart';

const S = 1.5;
final math.Random r = math.Random();

class Player extends AnimationComponent {

  static const SPEED = 80.0;

  int move = 0;

  Player() : super.sequenced(S * 48.0, S * 37.0, 'plane.png', 4, textureWidth: 48.0);

  @override
  void update(double dt) {
    super.update(dt);

    x += SPEED * move * dt;
  }

  @override
  void resize(Size size) {
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

class Background extends Component with Resizable {

  static const BG_SCALE = 5.0;
  static const SPEED = 5.0;

  Sprite bgSprite =  Sprite('clouds.png');
  Position p = Position.empty();
  Position velocity;

  Background() {
    this.velocity = Position(1.0, 0.0).rotate(2 * math.pi * r.nextDouble()).times(SPEED);
  }

  double get height => BG_SCALE * bgSprite.image.height;
  double get width => BG_SCALE * bgSprite.image.width;
  Position get imageSize => Position(width, height);

  @override
  void render(Canvas c) {
    if (!bgSprite.loaded()) {
      return;
    }
    c.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = Color(0xff639bff));
    bgSprite.renderPosition(c, p, imageSize);
    bgSprite.renderPosition(c, Position(p.x, p.y - height), imageSize);
    bgSprite.renderPosition(c, Position(p.x - width, p.y - height), imageSize);
    bgSprite.renderPosition(c, Position(p.x - width, p.y), imageSize);
  }

  @override
  void update(double t) {
    if (!bgSprite.loaded()) {
      return;
    }
    p.x += velocity.x * t;
    p.x = p.x % size.width;

    p.y += velocity.y * t;
    p.y = p.y % size.height;
  }

  @override
  int priority() => -1;
}

class MyGame extends BaseGame {

  static const SPAWN_TICK = 2.0;
  static const CHANCE_INCREASE_CHANCE = 0.1;
  static const CHANCE_INCREASE_MULTIPLIER = 1.1;

  double creationTimer = 0.0;
  double chanceOfSpawn = 0.5;

  Player player;

  MyGame() {
    add(player = Player());
    add(Background());
  }

  @override
  void update(double dt) {
    super.update(dt);

    creationTimer += dt;
    while (creationTimer >= SPAWN_TICK) {
      creationTimer -= SPAWN_TICK;
      tryCreateEnemy();
    }
  }

  tryCreateEnemy() {
    if (r.nextDouble() < chanceOfSpawn) {
      randomEnemy();
      if (r.nextDouble() < CHANCE_INCREASE_CHANCE) {
        chanceOfSpawn *= CHANCE_INCREASE_MULTIPLIER;
        chanceOfSpawn = chanceOfSpawn.clamp(0, 1);
      }
    }
  }

  randomEnemy() {
    add(Enemy(r.nextDouble() * size.width));
  }

  tapDown(Position p) {
    player.move = p.x >= player.x ? 1 : -1;
  }

  tapUp() {
    player.move = 0;
  }
}