import 'dart:convert';

import 'package:pride_sys_test_flutter/data/models/location_m.dart';
import 'package:pride_sys_test_flutter/data/models/origin_m.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

class CharacterModel extends CharacterEntity {
  CharacterModel({
    super.created,
    super.episodes,
    super.gender,
    super.id,
    super.image,
    super.locationEntity,
    super.name,
    super.originEntity,
    super.pageNumber,
    super.species,
    super.status,
    super.type,
    super.url,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json, int pageNumber) {
    return CharacterModel(
      created: json['created'] == null
          ? DateTime.now()
          : DateTime.tryParse(json['created']) ?? DateTime.now(),
      episodes: json['episode'],
      gender: json['gender'],
      id: json['id'],
      image: json['image'],
      locationEntity: (json['location'] is String)
          ? LocationModel.fromJson(jsonDecode(json['location']))
          : LocationModel.fromJson(json['location']),
      originEntity: (json['origin'] is String)
          ? OriginModel.fromJson(jsonDecode(json['origin']))
          : OriginModel.fromJson(json['origin']),
      name: json['name'],
      pageNumber: pageNumber,
      species: json['species'],
      status: json['status'],
      type: json['type'],
      url: json['url'],
    );
  }
}
