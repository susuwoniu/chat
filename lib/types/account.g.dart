// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionEntity _$ActionEntityFromJson(Map<String, dynamic> json) => ActionEntity(
      type: json['type'] as String,
      required: json['required'] as bool,
      content: json['content'] as String?,
    );

Map<String, dynamic> _$ActionEntityToJson(ActionEntity instance) =>
    <String, dynamic>{
      'type': instance.type,
      'required': instance.required,
      'content': instance.content,
    };

ThumbnailEntity _$ThumbnailEntityFromJson(Map<String, dynamic> json) =>
    ThumbnailEntity(
      mime_type: json['mime_type'] as String,
      url: json['url'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$ThumbnailEntityToJson(ThumbnailEntity instance) =>
    <String, dynamic>{
      'mime_type': instance.mime_type,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };

ImageEntity _$ImageEntityFromJson(Map<String, dynamic> json) => ImageEntity(
      mime_type: json['mime_type'] as String,
      url: json['url'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      size: json['size'] as int,
      thumbnail:
          ThumbnailEntity.fromJson(json['thumbnail'] as Map<String, dynamic>),
      large: ThumbnailEntity.fromJson(json['large'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImageEntityToJson(ImageEntity instance) =>
    <String, dynamic>{
      'mime_type': instance.mime_type,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
      'thumbnail': instance.thumbnail,
      "large": instance.large,
    };

AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) =>
    AccountEntity(
      profile_images: (json['profile_images'] as List<dynamic>?)
              ?.map((e) => ImageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bio: json['bio'] as String?,
      post_count: json['post_count'] as int,
      age: json['age'] as int?,
      birthday: json['birthday'] as String?,
      avatar:
          json['avatar'] != null ? ImageEntity.fromJson(json['avatar']) : null,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => ActionEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      phone_number: json['phone_number'] as String?,
      name: json['name'] as String,
      gender: json['gender'] as String,
      vip: json['vip'] as bool,
      likeCount: json['like_count'] as int,
      favorite_count: json['favorite_count'] as int,
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
      'phone_number': instance.phone_number,
      'name': instance.name,
      'gender': instance.gender,
      'like_count': instance.likeCount,
      'favorite_count': instance.favorite_count,
      'vip': instance.vip,
      'actions': instance.actions,
      'profile_images': instance.profile_images,
      'is_can_post': instance.is_can_post,
      'now': instance.now,
      'next_post_not_before': instance.next_post_not_before,
      'next_post_in_seconds': instance.next_post_in_seconds,
      'post_count': instance.post_count
    };
