import 'package:json_annotation/json_annotation.dart';
import 'package:chat/types/account.dart';

part 'simple_account.g.dart';

@JsonSerializable()
class SimpleAccountEntity {
  int like_count;
  bool is_liked;
  final String? avatar;
  final int? age;
  final String? bio;
  final String name;
  final bool vip;
  final String gender;
  final int post_count;
  bool is_blocked;
  List<ProfileImageEntity>? profile_images;

  SimpleAccountEntity({
    this.profile_images,
    this.avatar,
    this.age,
    this.bio,
    required this.is_liked,
    required this.name,
    required this.like_count,
    required this.vip,
    required this.gender,
    required this.is_blocked,
    required this.post_count,
  });
  static SimpleAccountEntity fromAccount(AccountEntity account) {
    return SimpleAccountEntity(
        avatar: account.avatar,
        profile_images: account.profile_images,
        age: account.age,
        bio: account.bio,
        is_liked: false,
        name: account.name,
        like_count: 0,
        vip: account.vip,
        gender: account.gender,
        is_blocked: false,
        post_count: account.post_count);
  }

  static SimpleAccountEntity empty() {
    return SimpleAccountEntity(
        name: "-",
        gender: "Unknown",
        vip: false,
        like_count: 0,
        is_liked: false,
        is_blocked: false,
        post_count: 0);
  }

  factory SimpleAccountEntity.fromJson(Map<String, dynamic> json) {
    if (json['is_liked'] == null) {
      json['is_liked'] = false;
    }
    if (json['is_blocked'] == null) {
      json['is_blocked'] = false;
    }
    if (json['bio'] == null) {
      json['bio'] = '';
    }
    return _$SimpleAccountEntityFromJson(json);
  }
  Map<String, dynamic> toJson() => _$SimpleAccountEntityToJson(this);
}
