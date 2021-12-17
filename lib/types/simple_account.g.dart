// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleAccountEntity _$SimpleAccountEntityFromJson(Map<String, dynamic> json) =>
    SimpleAccountEntity(
      profileImages: (json['profileImages'] as List<dynamic>?)
              ?.map(
                  (e) => ProfileImageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      avatar: json['avatar'] as String?,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      name: json['name'] as String,
      like_count: json['like_count'] as int,
      vip: json['vip'] as bool,
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$SimpleAccountEntityToJson(
        SimpleAccountEntity instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'age': instance.age,
      'bio': instance.bio,
      'name': instance.name,
      'like_count': instance.like_count,
      'vip': instance.vip,
      'gender': instance.gender,
      'profileImages': instance.profileImages,
    };
