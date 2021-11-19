import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class TokenEntity {
  /// The generated code assumes these values exist in JSON.
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'im_access_token')
  final String imAccessToken;
  @JsonKey(name: 'account_id')
  final String accountId;
  @JsonKey(name: 'access_token_expires_at')
  final DateTime accessTokenExpiresAt;
  @JsonKey(name: 'im_access_token_expires_at')
  final DateTime imAccessTokenExpiresAt;
  @JsonKey(name: 'refresh_token_expires_at')
  final DateTime refreshTokenExpiresAt;
  TokenEntity(
      {required this.accessToken,
      required this.refreshToken,
      required this.imAccessToken,
      required this.accountId,
      required this.accessTokenExpiresAt,
      required this.refreshTokenExpiresAt,
      required this.imAccessTokenExpiresAt});

  /// Connect the generated [_$TokenEntityFromJson] function to the `fromJson`
  /// factory.
  factory TokenEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenEntityFromJson(json);

  /// Connect the generated [_$TokenEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TokenEntityToJson(this);
}
