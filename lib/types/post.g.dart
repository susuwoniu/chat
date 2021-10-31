// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostEntity _$PostEntityFromJson(Map<String, dynamic> json) => PostEntity(
      id: json['id'] as String,
      content: json['content'] as String,
      backgroundColor: json['backgroundColor'] as String,
    );

Map<String, dynamic> _$PostEntityToJson(PostEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'backgroundColor': instance.backgroundColor,
    };
