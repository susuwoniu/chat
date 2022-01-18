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
      order: json['order'] as int,
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
      'order': instance.order,
      'thumbtail': instance.thumbtail,
    };

AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) =>
    AccountEntity(
      profile_images: (json['profile_images'] as List<dynamic>?)
              ?.map(
                  (e) => ProfileImageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      age: json['age'] as int?,
      birthday: json['birthday'] as String?,
      avatar: json['avatar'] as String?,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => ActionEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      phone_number: json['phone_number'] as String?,
      name: json['name'] as String,
      gender: json['gender'] as String,
      vip: json['vip'] as bool,
      likeCount: json['like_count'] as int,
      is_can_post: json['is_can_post'] as bool?,
      now: json['now'] as String?,
      next_post_not_before: json['next_post_not_before'] as String,
      next_post_in_seconds: json['next_post_in_seconds'] as int?,
    );

Map<String, dynamic> _$AccountEntityToJson(AccountEntity instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'age': instance.age,
      'birthday': instance.birthday,
      'bio': instance.bio,
      'location': instance.location,
      'phone_number': instance.phone_number,
      'name': instance.name,
      'gender': instance.gender,
      'like_count': instance.likeCount,
      'vip': instance.vip,
      'actions': instance.actions,
      'profile_images': instance.profile_images,
      'is_can_post': instance.is_can_post,
      'now': instance.now,
      'next_post_not_before': instance.next_post_not_before,
      'next_post_in_seconds': instance.next_post_in_seconds,
    };
