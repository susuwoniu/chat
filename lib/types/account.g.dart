// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionEntity _$ActionEntityFromJson(Map<String, dynamic> json) => ActionEntity(
      type: json['type'] as String,
      required: json['required'] as bool,
    );

Map<String, dynamic> _$ActionEntityToJson(ActionEntity instance) =>
    <String, dynamic>{
      'type': instance.type,
      'required': instance.required,
    };

AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) =>
    AccountEntity(
      name: json['name'] as String,
      gender: json['gender'] as String,
      accountId: json['accountId'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      birthday: json['birthday'] as String?,
      age: json['age'] as int?,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => ActionEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
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
      'accountId': instance.accountId,
      'actions': instance.actions,
    };
