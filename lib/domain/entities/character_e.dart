import 'package:pride_sys_test_flutter/domain/entities/location_e.dart';
import 'package:pride_sys_test_flutter/domain/entities/origin_e.dart';

class CharacterEntity{
  int? id;
  String? name;
  String? status;
  String? species;
  String? type;
  String? gender;
  OriginEntity? originEntity;
  LocationEntity? locationEntity;
  String? image;
  List<dynamic>? episodes;
  String? url;
  DateTime? created;
  int? pageNumber;

  CharacterEntity({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.originEntity,
    this.locationEntity,
    this.image,
    this.episodes,
    this.url,
    this.created,
    this.pageNumber,
  });

  CharacterEntity copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? origin,
    OriginEntity? originEntity,
    LocationEntity? locationEntity,
    String? image,
    List<String>? episodes,
    String? url,
    DateTime? created,
    int? pageNumber,
  }) {
    return CharacterEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      originEntity: originEntity ?? this.originEntity,
      locationEntity: locationEntity ?? this.locationEntity,
      image: image ?? this.image,
      episodes: episodes ?? this.episodes,
      url: url ?? this.url,
      created: created ?? this.created,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  String toString() {
    return 'CharacterEntity{id: $id, name: $name, status: $status, species: $species, type: $type, gender: $gender, originEntity: $originEntity, locationEntity: $locationEntity, image: $image, episodes: $episodes, url: $url, created: $created, pageNumber : $pageNumber}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CharacterEntity && runtimeType == other.runtimeType &&
              id == other.id && name == other.name && status == other.status &&
              species == other.species && type == other.type &&
              gender == other.gender &&
              originEntity == other.originEntity &&
              locationEntity == other.locationEntity && image == other.image &&
              episodes == other.episodes && url == other.url &&
              created == other.created && pageNumber == other.pageNumber;

  @override
  int get hashCode =>
      Object.hash(
          id,
          name,
          status,
          species,
          type,
          gender,
          originEntity,
          locationEntity,
          image,
          episodes,
          url,
          created, pageNumber);

}