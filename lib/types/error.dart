import 'package:json_annotation/json_annotation.dart';

part 'error.g.dart';

@JsonSerializable()
class ErrorEntity {
  /// The generated code assumes these values exist in JSON.
  final String title, code;
  final String detail;

  ErrorEntity({required this.title, required this.code, this.detail = ""});

  /// Connect the generated [_$ErrorEntityFromJson] function to the `fromJson`
  /// factory.
  factory ErrorEntity.fromJson(Map<String, dynamic> json) =>
      _$ErrorEntityFromJson(json);

  /// Connect the generated [_$ErrorEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ErrorEntityToJson(this);
}
