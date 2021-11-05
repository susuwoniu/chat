import 'package:get/get.dart';
import 'dart:convert';
import 'package:chat/types/types.dart';
import 'package:chat/errors/errors.dart';
import './raw_api_provider.dart';

class ApiProvider extends RawApiProvider {
  Future<TokenEntity> loginWithPhone() async {
    final dynamic body = {"timezone_in_seconds": 28800, "device_id": "ttttt"};
    final response =
        await post("/account/phone-sessions/86/15523324324/123456", body);

    return TokenEntity.fromJson(response.body.data.attributes);
  }
}
