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

ThumbtailEntity _$ThumbtailEntityFromJson(Map<String, dynamic> json) =>
    ThumbtailEntity(
      mime_type: json['mime_type'] as String,
      url: json['url'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$ThumbtailEntityToJson(ThumbtailEntity instance) =>
    <String, dynamic>{
      'mime_type': instance.mime_type,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };

ProfileImageEntity _$ProfileImageEntityFromJson(Map<String, dynamic> json) =>
    ProfileImageEntity(
      mime_type: json['mime_type'] as String,
      url: json['url'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      size: json['size'] as int,
      thumbtail:
          ThumbtailEntity.fromJson(json['thumbtail'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileImageEntityToJson(ProfileImageEntity instance) =>
    <String, dynamic>{
      'mime_type': instance.mime_type,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
      'thumbtail': instance.thumbtail,
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
