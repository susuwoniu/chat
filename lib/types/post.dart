import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostEntity {
  /// The generated code assumes these values exist in JSON.
  final String content;
  @JsonKey(name: 'background_color')
  final String backgroundColor;
  @JsonKey(name: 'account_id')
  final String accountId;
  final String cursor;
  List<String>? views;
  bool isLoadingViewersList;
  PostEntity({
    required this.content,
    required this.backgroundColor,
    required this.accountId,
    required this.cursor,
    this.views,
    this.isLoadingViewersList = false,
  });

  /// Connect the generated [_$PostEntityFromJson] function to the `fromJson`
  /// factory.
  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);

  /// Connect the generated [_$PostEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PostEntityToJson(this);
}
