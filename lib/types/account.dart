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
  factory ProfileImageEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileImageEntityToJson(this);
}

@JsonSerializable()
class AccountEntity {
  /// The generated code assumes these values exist in JSON.
  final String name;
  final String gender;
  final String? avatar;
  final int? age;
  final String? bio;
  final String? location;
  final String? birthday;
  @JsonKey(name: 'like_count')
  final int likeCount;
  final bool vip;
  final List<ActionEntity> actions;
  List<ProfileImageEntity> profileImages = [];

  AccountEntity(
      {required this.name,
      required this.gender,
      this.profileImages = const [],
      this.bio,
      this.location,
      this.birthday,
      this.age,
      this.avatar,
      this.actions = const [],
      required this.vip,
      required this.likeCount});
  static AccountEntity empty() {
    return AccountEntity(
      name: "-",
      gender: "unknown",
      vip: false,
      likeCount: 0,
    );
  }

  /// Connect the generated [_$AccountEntityFromJson] function to the `fromJson`
  /// factory.
  ///

  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);

  /// Connect the generated [_$AccountEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountEntityToJson(this);
}
