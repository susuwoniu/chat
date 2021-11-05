import 'package:get/get.dart';
import 'dart:convert';
import 'package:chat/types/types.dart';
import 'package:chat/errors/errors.dart';

const String API_PREFIX = "https://chat.scuinfo.com/api/v1";

class RawApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = API_PREFIX;
    httpClient.addRequestModifier<dynamic>((request) {
      request.url.pathSegments.insert(0, API_PREFIX);
      return request;
    });

    httpClient.addResponseModifier<dynamic>((request, response) {
      if (response.status.hasError) {
        // try parse json

        if (response.body &&
            response.body.errors &&
            response.body.errors.length > 0) {
          final error = response.body.errors[0];

          throw ServiceException(
              title: error.title, code: error.code, detail: error.detail);
        } else {
          throw ServiceException(
              title: "unknow_error_title".tr,
              code: response.status.toString(),
              detail: response.statusText ?? '');
        }
      }
      return response;
    });
  }
}
