import 'game_entity.dart';
import 'monster.dart';

class Character extends GameEntity {
  Character(String name, int health, int attack, int defense)
    : super(name, health, attack, defense);

  @override
  void attack(GameEntity target) {
    if (target is Monster) {
      int damage = attackPower - target.defense;
      damage = damage > 0 ? damage : 0;
      target.health -= damage;
      print('$name이(가) ${target.name}에게 $damage의 데미지를 입혔습니다.');
      // target.showStatus();
      // showStatus();
    }
  }

  void attackMonster(Monster monster) {
    attack(monster);
  }

  void defend() {
    print('$name이(가) 방어 태세를 취하여 $defense 만큼 체력을 얻었습니다.');
  }

  @override
  void showStatus() {
    print('$name - 체력: $health, 공격력: $attackPower, 방어력: $defense');
  }
}
