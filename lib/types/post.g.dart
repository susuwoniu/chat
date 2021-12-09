// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostEntity _$PostEntityFromJson(Map<String, dynamic> json) => PostEntity(
      content: json['content'] as String,
      backgroundColor: json['background_color'] as String,
      accountId: json['account_id'] as String,
      views:
          (json['views'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isLoadingViewersList: json['isLoadingViewersList'] as bool? ?? false,
    );

Map<String, dynamic> _$PostEntityToJson(PostEntity instance) =>
    <String, dynamic>{
      'content': instance.content,
      'background_color': instance.backgroundColor,
      'account_id': instance.accountId,
      'views': instance.views,
      'isLoadingViewersList': instance.isLoadingViewersList,
    };
