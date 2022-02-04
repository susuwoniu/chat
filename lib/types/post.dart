import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostEntity {
  /// The generated code assumes these values exist in JSON.
  final String content;
  @JsonKey(name: 'background_color')
  final int backgroundColor;
  @JsonKey(name: 'color')
  final int color;
  @JsonKey(name: 'account_id')
  final String accountId;
  final String cursor;
  final String post_template_id;
  List<String>? views;
  bool isLoadingViewersList;
  final String post_template_title;
  final String created_at;
  final String visibility;
  bool is_can_promote;

  PostEntity({
    required this.content,
    required this.backgroundColor,
    required this.color,
    required this.accountId,
    required this.cursor,
    required this.post_template_id,
    required this.post_template_title,
    this.views,
    this.isLoadingViewersList = false,
    required this.created_at,
    required this.visibility,
    required this.is_can_promote,
  });

  /// Connect the generated [_$PostEntityFromJson] function to the `fromJson`
  /// factory.
  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);

  /// Connect the generated [_$PostEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PostEntityToJson(this);
}
