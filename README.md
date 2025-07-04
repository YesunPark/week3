# 전투 RPG 게임

Dart로 구현된 콘솔 기반 전투 RPG 게임 - 내배캠 3주차 과제

## 게임 실행 방법

```bash
dart run
```

## 파일 구조

- `characters.txt`: 캐릭터 기본 스탯 (체력,공격력,방어력)
- `monsters.txt`: 몬스터 정보 (이름,체력,최대공격력)
- `result.txt`: 게임 결과 저장 파일

## 클래스 구조

- `GameEntity`: 캐릭터와 몬스터의 공통 속성
- `Character`: 플레이어 캐릭터 클래스
- `Monster`: 몬스터 클래스
- `Game`: 게임 전체 로직 관리 클래스
