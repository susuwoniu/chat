import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountEntity {
  /// The generated code assumes these values exist in JSON.
  final String id, name;
  final int? age;

  AccountEntity({required this.id, required this.name, this.age});

  /// Connect the generated [_$AccountEntityFromJson] function to the `fromJson`
  /// factory.
  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);

  /// Connect the generated [_$AccountEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AccountEntityToJson(this);
}
