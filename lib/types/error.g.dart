// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorEntity _$ErrorEntityFromJson(Map<String, dynamic> json) => ErrorEntity(
      title: json['title'] as String,
      code: json['code'] as String,
      detail: json['detail'] as String? ?? "",
    );

Map<String, dynamic> _$ErrorEntityToJson(ErrorEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'code': instance.code,
      'detail': instance.detail,
    };
