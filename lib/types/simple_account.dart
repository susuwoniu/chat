import 'package:json_annotation/json_annotation.dart';
import 'package:chat/types/account.dart';

part 'simple_account.g.dart';

@JsonSerializable()
class SimpleAccountEntity {
  final String? avatar;
  final int? age;
  final String? bio;

  final String name;
  int like_count;
  bool is_liked;
  String location;
  final String birthday;

  final bool vip;
  final String gender;
  List<ProfileImageEntity>? profile_images;

  SimpleAccountEntity({
    this.profile_images,
    this.avatar,
    this.age,
    this.bio,
    this.birthday = 'xxxx-xx-xx',
    this.is_liked = false,
    this.location = 'unknown_place',
    required this.name,
    required this.like_count,
    required this.vip,
    required this.gender,
  });
  static SimpleAccountEntity empty() {
    return SimpleAccountEntity(
      name: "-",
      gender: "unknown",
      vip: false,
      like_count: 0,
    );
  }

  factory SimpleAccountEntity.fromJson(Map<String, dynamic> json) {
    if (json['is_liked'] == null ||
        json['location'] == null ||
        json['bio'] == null ||
        json['birthday'] == null) {
      json['is_liked'] = false;
      json['location'] = 'unknown_place';
      json['bio'] = 'nothing...';
      json['birthday'] = 'xxxx-xx-xx';
    }
    return _$SimpleAccountEntityFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SimpleAccountEntityToJson(this);
}
