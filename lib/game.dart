import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

class Game {
  Character? character;
  List<Monster> monsters = [];
  int requiredKills;

  Game({this.requiredKills = 2});

  void loadCharacterStats() {
    try {
      final file = File('characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');
      if (stats.length != 3) throw FormatException('Invalid character data');
      int health = int.parse(stats[0].trim());
      int attack = int.parse(stats[1].trim());
      int defense = int.parse(stats[2].trim());
      String name = getCharacterName();
      character = Character(name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  void loadMonsterStats() {
    try {
      final file = File('monsters.txt');
      final contents = file.readAsStringSync();
      final lines = contents.split('\n');
      for (String line in lines) {
        if (line.trim().isEmpty) continue;
        final stats = line.split(',');
        if (stats.length != 3) continue;
        String name = stats[0].trim();
        int health = int.parse(stats[1].trim());
        int maxAttack = int.parse(stats[2].trim());
        monsters.add(Monster(name, health, maxAttack));
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  String getCharacterName() {
    RegExp namePattern = RegExp(r'^[a-zA-Z가-힣]+$');
    String? name;
    while (true) {
      print('캐릭터의 이름을 입력하세요:');
      name = stdin.readLineSync()?.trim();
      if (name == null || name.isEmpty) {
        print('이름을 입력해주세요!');
        continue;
      }
      if (!namePattern.hasMatch(name)) {
        print('이름에는 한글과 영문 대소문자만 사용할 수 있습니다!');
        continue;
      }
      break;
    }
    return name!;
  }

  Monster getRandomMonster() {
    if (monsters.isEmpty) {
      throw Exception('더 이상 몬스터가 없습니다!');
    }
    return monsters[Random().nextInt(monsters.length)];
  }

  void battle() {
    if (character == null) return;
    Monster currentMonster = getRandomMonster();
    print('\n새로운 몬스터가 나타났습니다!');
    currentMonster.showStatus();
    while (character!.isAlive() && currentMonster.isAlive()) {
      print('\n${character!.name}의 턴');
      // character!.showStatus();
      print('행동을 선택하세요 (1: 공격, 2: 방어):');
      String? choice = stdin.readLineSync()?.trim();
      if (choice == '2') {
        character!.defend();
      } else {
        character!.attackMonster(currentMonster);
      }
      if (currentMonster.isAlive()) {
        print('\n${currentMonster.name}의 턴');
        currentMonster.attackCharacter(character!);
        character!.showStatus();
        currentMonster.showStatus();
      }
    }
    if (currentMonster.health <= 0) {
      print('${currentMonster.name}(을)를 물리쳤습니다!');
      monsters.remove(currentMonster);
    }
  }

  void startGame() {
    loadCharacterStats();
    loadMonsterStats();
    print('게임을 시작합니다!');
    character!.showStatus();
    int killedCount = 0;
    while (character!.isAlive() && monsters.isNotEmpty) {
      battle();
      killedCount++;
      if (monsters.isNotEmpty && character!.isAlive()) {
        print('\n다음 몬스터와 싸우시겠습니까? (y/n):');
        String? continueChoice = stdin.readLineSync()?.trim().toLowerCase();
        if (continueChoice != 'y') {
          break;
        }
      }
    }
    if (monsters.isEmpty && character!.isAlive()) {
      print('축하합니다! 모든 몬스터를 물리쳤습니다.');
      saveResult(true);
    } else if (!character!.isAlive()) {
      print('아쉽게도 패배하였습니다.');
      saveResult(false);
    }
  }

  void saveResult(bool isVictory) {
    print('결과를 저장하시겠습니까? (y/n):');
    String? saveChoice = stdin.readLineSync()?.trim().toLowerCase();
    if (saveChoice == 'y') {
      try {
        final file = File('result.txt');
        String result = isVictory ? '승리' : '패배';
        String content =
            '캐릭터: ${character!.name}\n남은 체력: ${character!.health}\n게임 결과: $result';
        file.writeAsStringSync(content);
        print('결과가 result.txt 파일에 저장되었습니다.');
      } catch (e) {
        print('결과 저장에 실패했습니다: $e');
      }
    }
  }
}
