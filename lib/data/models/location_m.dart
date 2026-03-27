import 'package:pride_sys_test_flutter/domain/entities/location_e.dart';

class LocationModel extends LocationEntity {
  LocationModel({super.name, super.url});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(name: json['name'], url: json['url']);
  }
  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "url" : url,
    };
  }
}
