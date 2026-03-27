import 'package:pride_sys_test_flutter/domain/entities/origin_e.dart';

class OriginModel extends OriginEntity {
  OriginModel({super.name, super.url});

  factory OriginModel.fromJson(Map<String, dynamic> json) {
    return OriginModel(name: json['name'], url: json['url']);
  }

  Map<String,dynamic> toJson(){
    return {
      "name": name,
      "url" : url,
    };
  }
}
