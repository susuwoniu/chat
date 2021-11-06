import 'dart:async';
import 'package:get/get.dart' hide FormData;
import 'package:chat/constants/constants.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:chat/errors/errors.dart';

class GetClient extends GetConnect {
  @override
  GetHttpClient get httpClient {
    final baseUrl = API_PREFIX;
    final client = GetHttpClient(
      userAgent: userAgent,
      sendUserAgent: sendUserAgent,
      timeout: timeout,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      maxAuthRetries: maxAuthRetries,
      allowAutoSignedCert: allowAutoSignedCert,
      baseUrl: baseUrl,
      trustedCertificates: trustedCertificates,
      withCredentials: withCredentials,
    );
    return client;
  }
}

class APIProvider {
  static APIProvider instance = APIProvider._internal();
  factory APIProvider() => instance;

  late GetClient client;

  APIProvider._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数

    client = GetClient();
  }

  /// 读取本地配置
  Map<String, String>? getAuthorizationHeader() {
    var headers = <String, String>{};
    // if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
    //   headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    // }
    return headers;
  }

  /// restful post 操作
  Future raw_request(
    String path,
    String method, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final response = await client.request(path, method,
        body: body, query: query, headers: headers);

    if (response.hasError) {
      throw formatError(response);
    } else {
      return response;
    }
  }

  /// restful request 操作
  Future request(
    String path,
    String method, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    headers = headers ?? {};
    Map<String, String>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      headers.addAll(authorization);
    }
    try {
      final response = await raw_request(path, method,
          body: body, query: query, headers: headers);
      return response.body;
    } on ServiceException catch (e) {
      UIUtils.hideLoading();
      await UIUtils.snackbar(e.title, e.detail);
      rethrow;
    }
  }

  /// restful get 操作
  /// refresh 是否下拉刷新 默认 false
  /// noCache 是否不缓存 默认 true
  /// list 是否列表 默认 false
  /// cacheKey 缓存key
  /// cacheDisk 是否磁盘缓存
  Future get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    var response = await request(
      path,
      "GET",
      query: query,
      headers: headers,
    );
    return response;
  }

  /// restful post 操作
  Future post(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    var response = await request(
      path,
      "POST",
      body: body,
      query: query,
      headers: headers,
    );
    return response;
  }

  Future put(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    var response = await request(
      path,
      "PUT",
      body: body,
      query: query,
      headers: headers,
    );
    return response;
  }

  Future patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    var response = await request(
      path,
      "PATCH",
      body: body,
      query: query,
      headers: headers,
    );
    return response;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    var response = await request(
      path,
      "DELETE",
      body: body,
      query: query,
      headers: headers,
    );
    return response;
  }
}

// 错误信息
formatError(Response response) {
  if (response.body != null) {
    final data = response.body!;
    final statusCode = response.statusCode!;
    String title, code, detail;
    if (data.containsKey("errors") && data["errors"].length > 0) {
      final error = data["errors"][0];
      title = error["title"];
      code = error["code"];
      detail = error["detail"];
    } else {
      title = "unknow_error_title".tr;
      code = statusCode.toString();
      detail = response.statusText ?? '';
    }

    return ServiceException(title, code: code, detail: detail);
  } else if (response.statusCode != null) {
    final statusCode = response.statusCode!;
    switch (statusCode) {
      case 400:
        return ServiceException.withCode("bad_request_error".tr,
            code: "bad_request");
      case 401:
        return ServiceException.withCode("unauthorized_error".tr,
            code: "unauthorized_error");
      case 403:
        return ServiceException.withCode("forbidden_error".tr,
            code: "forbidden_error");
      case 404:
        return ServiceException.withCode("not_found_error".tr,
            code: "not_found_error");
      case 405:
        return ServiceException.withCode("method_not_allowed_error".tr,
            code: "method_not_allowed_error");
      case 500:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_500");
      case 502:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_502");
      case 503:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_503");
      case 505:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_505");
      default:
        {
          return ServiceException.withCode("server_internal_error".tr,
              code: "server_internal_error_" + statusCode.toString());
        }
    }
  }
}
