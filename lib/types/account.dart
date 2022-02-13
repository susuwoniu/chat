import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class ActionEntity {
  final String type;
  final bool required;
  final String? content;
  ActionEntity({required this.type, required this.required, this.content});
  factory ActionEntity.fromJson(Map<String, dynamic> json) =>
      _$ActionEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ActionEntityToJson(this);
}

@JsonSerializable()
class ThumbnailEntity {
  final String mime_type;
  final String url;
  final double width;
  final double height;

  ThumbnailEntity({
    required this.mime_type,
    required this.url,
    required this.width,
    required this.height,
  });
  factory ThumbnailEntity.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailEntityToJson(this);
}

@JsonSerializable()
class ImageEntity {
  final String mime_type;
  String url;
  final double width;
  final double height;
  final int size;
  ThumbnailEntity thumbnail;
  ThumbnailEntity large;
  ImageEntity(
      {required this.mime_type,
      required this.url,
      required this.width,
      required this.height,
      required this.size,
      required this.thumbnail,
      required this.large});
  static ImageEntity empty() {
    return ImageEntity(
        mime_type: "image/jpg",
        url:
            "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
        width: 140,
        height: 140,
        size: 45,
        thumbnail: ThumbnailEntity(
            height: 140,
            width: 140,
            url:
                "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
            mime_type: "image/jpg"),
        large: ThumbnailEntity(
            height: 140,
            width: 140,
            url:
                "http://p1.music.126.net/jcKLW8e0n4dqVywaBvGqrA==/109951166712826330.jpg?param=140y140",
            mime_type: "image/jpg"));
  }

  factory ImageEntity.fromJson(Map<String, dynamic> json) =>
      _$ImageEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ImageEntityToJson(this);
}

@JsonSerializable()
class AccountEntity {
  /// The generated code assumes these values exist in JSON.

  final ImageEntity? avatar;
  final int? age;
  String? birthday;
  final String? bio;
  int post_count;
  final String? phone_number;
  String next_post_not_before;
  int? next_post_in_seconds;

  final String name;
  final String gender;
  @JsonKey(name: 'like_count')
  final int likeCount;
  final bool vip;
  final String? now;
  bool? is_can_post;
  final List<ActionEntity> actions;
  List<ImageEntity> profile_images = [];

  AccountEntity(
      {this.profile_images = const [],
      this.bio,
      this.age,
      this.birthday,
      required this.post_count,
      this.avatar,
      this.actions = const [],
      this.phone_number,
      required this.next_post_not_before,
      this.next_post_in_seconds,
      required this.name,
      required this.gender,
      required this.vip,
      this.now,
      this.is_can_post,
      required this.likeCount});
  static AccountEntity empty() {
    return AccountEntity(
        name: "--",
        gender: "Unknown",
        vip: false,
        likeCount: 0,
        post_count: 0,
        next_post_not_before: '2014-10-14T16:32:41.018Z');
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
