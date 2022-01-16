import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class ActionEntity {
  final String type;
  final bool required;
  ActionEntity({
    required this.type,
    required this.required,
  });
  factory ActionEntity.fromJson(Map<String, dynamic> json) =>
      _$ActionEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ActionEntityToJson(this);
}

@JsonSerializable()
class ThumbtailEntity {
  final String mime_type;
  final String url;
  final double width;
  final double height;

  ThumbtailEntity({
    required this.mime_type,
    required this.url,
    required this.width,
    required this.height,
  });
  factory ThumbtailEntity.fromJson(Map<String, dynamic> json) =>
      _$ThumbtailEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbtailEntityToJson(this);
}

@JsonSerializable()
class ProfileImageEntity {
  final String mime_type;
  String url;
  final double width;
  final double height;
  final int size;
  final int order;
  ThumbtailEntity thumbtail;

  ProfileImageEntity({
    required this.mime_type,
    required this.url,
    required this.width,
    required this.height,
    required this.order,
    required this.size,
    required this.thumbtail,
  });
  static ProfileImageEntity empty() {
    return ProfileImageEntity(
        mime_type: "image/jpg",
        url:
            "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
        width: 140,
        height: 140,
        size: 45,
        order: 0,
        thumbtail: ThumbtailEntity(
            height: 140,
            width: 140,
            url:
                "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
            mime_type: "image/jpg"));
  }

  factory ProfileImageEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileImageEntityToJson(this);
}

@JsonSerializable()
class AccountEntity {
  /// The generated code assumes these values exist in JSON.

  final String? avatar;
  final int? age;
  String? birthday;
  final String? bio;
  final String? location;
  final String? phone_number;
  final String? next_post_not_before;

  final String name;
  final String gender;
  @JsonKey(name: 'like_count')
  final int likeCount;
  final bool vip;
  bool? is_can_post;
  final List<ActionEntity> actions;
  List<ProfileImageEntity> profile_images = [];

  AccountEntity(
      {this.profile_images = const [],
      this.bio,
      this.location,
      this.age,
      this.birthday,
      this.avatar,
      this.actions = const [],
      this.phone_number,
      this.next_post_not_before,
      required this.name,
      required this.gender,
      required this.vip,
      this.is_can_post,
      required this.likeCount});
  static AccountEntity empty() {
    return AccountEntity(
      name: "--",
      gender: "Unknown",
      vip: false,
      likeCount: 0,
    );
  }

  /// Connect the generated [_$AccountEntityFromJson] function to the `fromJson`
  /// factory.
  ///

  factory AccountEntity.fromJson(Map<String, dynamic> json) {
    if (json['gender'] == null) {
      json['gender'] = 'Unknown';
    }
    if (json['location'] == null) {
      json['location'] = '';
    }
    if (json['is_can_post'] == null) {
      json['is_can_post'] = true;
    }

    return _$AccountEntityFromJson(json);
  }

  /// Connect the generated [_$AccountEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountEntityToJson(this);
}
