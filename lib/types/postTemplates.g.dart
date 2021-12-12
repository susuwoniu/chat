// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postTemplates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostTemplatesEntity _$PostTemplatesEntityFromJson(Map<String, dynamic> json) =>
    PostTemplatesEntity(
      content: json['content'] as String,
      backgroundColor: json['background_color'] as String,
    );

Map<String, dynamic> _$PostTemplatesEntityToJson(
        PostTemplatesEntity instance) =>
    <String, dynamic>{
      'content': instance.content,
      'background_color': instance.backgroundColor,
    };
