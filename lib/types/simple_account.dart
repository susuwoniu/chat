import 'package:json_annotation/json_annotation.dart';

part 'simple_account.g.dart';

@JsonSerializable()
class SimpleAccountEntity {
  final String? avatar;
  final String name;

  SimpleAccountEntity({
    required this.avatar,
    required this.name,
  });
  factory SimpleAccountEntity.fromJson(Map<String, dynamic> json) =>
      _$SimpleAccountEntityFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleAccountEntityToJson(this);
}
