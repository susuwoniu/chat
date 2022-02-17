import 'package:json_annotation/json_annotation.dart';
import 'post.dart';

part 'favorite.g.dart';

@JsonSerializable()
class FavoriteEntity {
  final String post_id;

  FavoriteEntity({required this.post_id});

  factory FavoriteEntity.fromJson(Map<String, dynamic> json) {
    return _$FavoriteEntityFromJson(json);
  }

  /// Connect the generated [_$FavoriteEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$FavoriteEntityToJson(this);
}
