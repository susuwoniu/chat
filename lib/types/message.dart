import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class MessageEntity {
  /// The generated code assumes these values exist in JSON.
  final String id, text, name;

  MessageEntity({
    required this.id,
    required this.text,
    required this.name,
  });

  /// Connect the generated [_$MessageEntityFromJson] function to the `fromJson`
  /// factory.
  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  /// Connect the generated [_$MessageEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MessageEntityToJson(this);
}
