import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostEntity {
  /// The generated code assumes these values exist in JSON.
  final String id, content, backgroundColor;

  PostEntity(
      {required this.id,
      required this.content,
      required this.backgroundColor,
      create});

  /// Connect the generated [_$PostEntityFromJson] function to the `fromJson`
  /// factory.
  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);

  /// Connect the generated [_$PostEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PostEntityToJson(this);
}
