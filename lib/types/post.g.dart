// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostEntity _$PostEntityFromJson(Map<String, dynamic> json) => PostEntity(
      content: json['content'] as String,
      backgroundColor: json['background_color'] as int,
      accountId: json['account_id'] as String,
      cursor: json['cursor'] as String,
      post_template_id: json['post_template_id'] as String,
      views:
          (json['views'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isLoadingViewersList: json['isLoadingViewersList'] as bool? ?? false,
    );

Map<String, dynamic> _$PostEntityToJson(PostEntity instance) =>
    <String, dynamic>{
      'content': instance.content,
      'background_color': instance.backgroundColor,
      'account_id': instance.accountId,
      'cursor': instance.cursor,
      'post_template_id': instance.post_template_id,
      'views': instance.views,
      'isLoadingViewersList': instance.isLoadingViewersList,
    };
