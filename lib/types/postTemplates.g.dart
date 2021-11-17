// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postTemplates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostTemplatesEntity _$PostTemplatesEntityFromJson(Map<String, dynamic> json) =>
    PostTemplatesEntity(
      id: json['id'] as String,
      content: json['content'] as String,
      backgroundColor: json['backgroundColor'] as String,
    );

Map<String, dynamic> _$PostTemplatesEntityToJson(
        PostTemplatesEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'backgroundColor': instance.backgroundColor,
    };
