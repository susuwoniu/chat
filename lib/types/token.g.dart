// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenEntity _$TokenEntityFromJson(Map<String, dynamic> json) => TokenEntity(
      access_token: json['access_token'] as String,
      refresh_token: json['refresh_token'] as String,
      account_id: json['account_id'] as String,
      expires_at: DateTime.parse(json['expires_at'] as String),
      refresh_token_expires_at:
          DateTime.parse(json['refresh_token_expires_at'] as String),
    );

Map<String, dynamic> _$TokenEntityToJson(TokenEntity instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'refresh_token': instance.refresh_token,
      'account_id': instance.account_id,
      'expires_at': instance.expires_at.toIso8601String(),
      'refresh_token_expires_at':
          instance.refresh_token_expires_at.toIso8601String(),
    };
