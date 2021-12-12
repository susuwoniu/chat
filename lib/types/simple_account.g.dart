// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleAccountEntity _$SimpleAccountEntityFromJson(Map<String, dynamic> json) =>
    SimpleAccountEntity(
      avatar: json['avatar'] as String?,
      name: json['name'] as String,
      like_count: json['like_count'] as int,
    );

Map<String, dynamic> _$SimpleAccountEntityToJson(
        SimpleAccountEntity instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'name': instance.name,
      'like_count': instance.like_count,
    };
