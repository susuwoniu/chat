// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleAccountEntity _$SimpleAccountEntityFromJson(Map<String, dynamic> json) =>
    SimpleAccountEntity(
      profile_images: (json['profile_images'] as List<dynamic>?)
              ?.map((e) => ImageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      avatar:
          json['avatar'] != null ? ImageEntity.fromJson(json['avatar']) : null,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      name: json['name'] as String,
      like_count: json['like_count'] as int,
      is_liked: json['is_liked'] as bool,
      vip: json['vip'] as bool,
      gender: json['gender'] as String,
      is_blocked: json['is_blocked'] as bool,
      post_count: json['post_count'] as int,
    );

Map<String, dynamic> _$SimpleAccountEntityToJson(
        SimpleAccountEntity instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'age': instance.age,
      'bio': instance.bio,
      'name': instance.name,
      'like_count': instance.like_count,
      'is_liked': instance.is_liked,
      'vip': instance.vip,
      'gender': instance.gender,
      'profile_images': instance.profile_images,
      'is_blocked': instance.is_blocked,
      'post_count': instance.post_count
    };
