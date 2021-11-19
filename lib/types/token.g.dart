// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenEntity _$TokenEntityFromJson(Map<String, dynamic> json) => TokenEntity(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      imAccessToken: json['im_access_token'] as String,
      accountId: json['account_id'] as String,
      accessTokenExpiresAt:
          DateTime.parse(json['access_token_expires_at'] as String),
      refreshTokenExpiresAt:
          DateTime.parse(json['refresh_token_expires_at'] as String),
      imAccessTokenExpiresAt:
          DateTime.parse(json['im_access_token_expires_at'] as String),
    );

Map<String, dynamic> _$TokenEntityToJson(TokenEntity instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'im_access_token': instance.imAccessToken,
      'account_id': instance.accountId,
      'access_token_expires_at':
          instance.accessTokenExpiresAt.toIso8601String(),
      'im_access_token_expires_at':
          instance.imAccessTokenExpiresAt.toIso8601String(),
      'refresh_token_expires_at':
          instance.refreshTokenExpiresAt.toIso8601String(),
    };
