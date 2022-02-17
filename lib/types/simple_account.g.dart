// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleAccountEntity _$SimpleAccountEntityFromJson(Map<String, dynamic> json) =>
    SimpleAccountEntity(
      profile_images: (json['profile_images'] as List<dynamic>?)
          ?.map((e) => ImageEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      avatar: json['avatar'] == null
          ? null
          : ImageEntity.fromJson(json['avatar'] as Map<String, dynamic>),
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      is_liked: json['is_liked'] as bool,
      name: json['name'] as String,
      like_count: json['like_count'] as int,
      vip: json['vip'] as bool,
      gender: json['gender'] as String,
      is_blocked: json['is_blocked'] as bool,
      post_count: json['post_count'] as int,
    );

Map<String, dynamic> _$SimpleAccountEntityToJson(
        SimpleAccountEntity instance) =>
    <String, dynamic>{
      'like_count': instance.like_count,
      'is_liked': instance.is_liked,
      'avatar': instance.avatar,
      'age': instance.age,
      'bio': instance.bio,
      'name': instance.name,
      'vip': instance.vip,
      'gender': instance.gender,
      'post_count': instance.post_count,
      'is_blocked': instance.is_blocked,
      'profile_images': instance.profile_images,
    };
