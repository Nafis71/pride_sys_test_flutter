import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

/// One page from the character API: items plus whether another page exists.
class CharacterPageEntity {
  CharacterPageEntity({
    required this.characters,
    required this.hasMore,
  });

  final List<CharacterEntity> characters;
  final bool hasMore;
}
