import 'package:json_annotation/json_annotation.dart';

part 'postTemplates.g.dart';

@JsonSerializable()
class PostTemplatesEntity {
  /// The generated code assumes these values exist in JSON.
  final String id, content, backgroundColor;

  PostTemplatesEntity(
      {required this.id,
      required this.content,
      required this.backgroundColor,
      create});

  /// Connect the generated [_$PostTemplatesEntityFromJson] function to the `fromJson`
  /// factory.
  factory PostTemplatesEntity.fromJson(Map<String, dynamic> json) =>
      _$PostTemplatesEntityFromJson(json);

  /// Connect the generated [_$PostTemplatesEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PostTemplatesEntityToJson(this);
}
