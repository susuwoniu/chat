import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountEntity {
  /// The generated code assumes these values exist in JSON.
  final String name;
  final String gender;
  final int? age;
  final String? bio;
  final String? location;
  final String? birthday;
  @JsonKey(name: 'like_count')
  final int likeCount;
  final bool vip;

  AccountEntity(
      {required this.name,
      required this.gender,
      this.bio,
      this.location,
      this.birthday,
      this.age,
      required this.vip,
      required this.likeCount});

  /// Connect the generated [_$AccountEntityFromJson] function to the `fromJson`
  /// factory.
  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);

  /// Connect the generated [_$AccountEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountEntityToJson(this);
}
