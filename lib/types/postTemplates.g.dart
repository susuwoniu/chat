// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postTemplates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostTemplatesEntity _$PostTemplatesEntityFromJson(Map<String, dynamic> json) =>
    PostTemplatesEntity(
      content: json['content'] as String?,
      title: json['title'] as String,
    );

Map<String, dynamic> _$PostTemplatesEntityToJson(
        PostTemplatesEntity instance) =>
    <String, dynamic>{
      'content': instance.content,
      'title': instance.title,
    };
