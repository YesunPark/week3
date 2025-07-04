import 'dart:math';
import 'game_entity.dart';
import 'character.dart';

class Monster extends GameEntity {
  int maxAttackPower;

  Monster(String name, int health, int maxAttackPower)
    : this.maxAttackPower = maxAttackPower,
      super(name, health, _generateRandomAttack(maxAttackPower), 0);

  static int _generateRandomAttack(int maxAttackPower) {
    return Random().nextInt(maxAttackPower) + 1;
  }

  @override
  void attack(GameEntity target) {
    if (target is Character) {
      int damage = attackPower - target.defense;
      damage = damage > 0 ? damage : 0;
      target.health -= damage;
      print('$name(이)가 ${target.name}에게 $damage의 데미지를 입혔습니다.');
    }
  }

  void attackCharacter(Character character) {
    attack(character);
  }

  @override
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower');
  }
}
