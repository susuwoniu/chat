import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class TokenEntity {
  /// The generated code assumes these values exist in JSON.
  final String access_token, refresh_token, account_id;
  final DateTime expires_at, refresh_token_expires_at;
  TokenEntity(
      {required this.access_token,
      required this.refresh_token,
      required this.account_id,
      required this.expires_at,
      required this.refresh_token_expires_at});
  static TokenEntity getDefault() {
    return TokenEntity(
      access_token: "",
      refresh_token: "",
      account_id: "",
      expires_at: DateTime.now(),
      refresh_token_expires_at: DateTime.now(),
    );
  }

  /// Connect the generated [_$TokenEntityFromJson] function to the `fromJson`
  /// factory.
  factory TokenEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenEntityFromJson(json);

  /// Connect the generated [_$TokenEntityToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$TokenEntityToJson(this);
}
