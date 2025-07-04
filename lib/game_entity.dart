abstract class GameEntity {
  String name;
  int health;
  int attackPower;
  int defense;

  GameEntity(this.name, this.health, this.attackPower, this.defense);

  void attack(GameEntity target);
  void showStatus();
  bool isAlive() => health > 0;
}
