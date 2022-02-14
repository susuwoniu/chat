// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostEntity _$PostEntityFromJson(Map<String, dynamic> json) => PostEntity(
      content: json['content'] as String,
      backgroundColor: json['background_color'] as int,
      color: json['color'] as int,
      accountId: json['account_id'] as String,
      cursor: json['cursor'] as String,
      post_template_id: json['post_template_id'] as String,
      views:
          (json['views'] as List<dynamic>?)?.map((e) => e as String).toList(),
      post_template_title: json['post_template_title'] as String,
      visibility: json['visibility'] as String,
      created_at: json['created_at'] as String,
      is_can_promote: json['is_can_promote'] as bool,
      viewed_count: json['viewed_count'] as int,
    );

Map<String, dynamic> _$PostEntityToJson(PostEntity instance) =>
    <String, dynamic>{
      'content': instance.content,
      'background_color': instance.backgroundColor,
      'account_id': instance.accountId,
      'color': instance.color,
      'cursor': instance.cursor,
      'post_template_id': instance.post_template_id,
      'views': instance.views,
      'post_template_title': instance.post_template_title,
      'created_at': instance.created_at,
      'visibility': instance.visibility,
      'is_can_promote': instance.is_can_promote,
      'viewed_count': instance.viewed_count
    };
