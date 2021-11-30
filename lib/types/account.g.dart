// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) =>
    AccountEntity(
      name: json['name'] as String,
      gender: json['gender'] as String,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      birthday: json['birthday'] as String?,
      age: json['age'] as int?,
      vip: json['vip'] as bool,
      likeCount: json['like_count'] as int,
    );

Map<String, dynamic> _$AccountEntityToJson(AccountEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'gender': instance.gender,
      'age': instance.age,
      'bio': instance.bio,
      'location': instance.location,
      'birthday': instance.birthday,
      'like_count': instance.likeCount,
      'vip': instance.vip,
    };
