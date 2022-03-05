import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart' hide FormData;
import 'package:chat/app/ui_utils/ui_utils.dart';
import 'package:chat/errors/errors.dart';
import 'package:chat/config/config.dart';
import 'package:chat/utils/security.dart';
import 'package:chat/utils/log.dart';
import 'auth_provider.dart';
import 'package:chat/types/types.dart';
import 'dart:io' show Platform;

// import 'package'
class ApiOptions {
  bool withSignature = false;
  bool withAuthorization = true;
  bool withDefaultHeaders = true;
  bool? checkDataAttributes;
  ApiOptions(
      {this.withSignature = true,
      this.withAuthorization = true,
      this.withDefaultHeaders = true,
      this.checkDataAttributes});
}

class GetClient extends GetConnect {
  @override
  GetHttpClient get httpClient {
    final client = GetHttpClient(
      userAgent: userAgent,
      sendUserAgent: sendUserAgent,
      timeout: timeout,
      followRedirects: followRedirects,
      maxRedirects: maxRedirects,
      maxAuthRetries: maxAuthRetries,
      allowAutoSignedCert: allowAutoSignedCert,
      trustedCertificates: trustedCertificates,
      withCredentials: withCredentials,
    );
    return client;
  }
}

class APIProvider {
  static final APIProvider _instance = APIProvider._internal();
  static APIProvider get to => _instance;
  factory APIProvider() => _instance;
  late GetClient client;

  APIProvider._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数

    client = GetClient();
  }

  Future<TokenEntity> renewToken() async {
    // refresh token
    if (AuthProvider.to.isNeedRenewToken() &&
        AuthProvider.to.refreshToken != null) {
      // 续期token
      // /account/access-tokens
      try {
        final tokenBody = await post("/account/access-tokens",
            headers: {
              'Authorization': "Bearer ${AuthProvider.to.refreshToken}"
            },
            options: ApiOptions(
                withAuthorization: false,
                withSignature: true,
                checkDataAttributes: true));
        final token = TokenEntity.fromJson(tokenBody["data"]["attributes"]);
        // save token
        await AuthProvider.to.saveToken(token);
        // continue request
        return token;
      } catch (e) {
        await AuthProvider.to.cleanToken();
        rethrow;
      }
    } else {
      // remove refreshToken
      throw ServiceException.withCode("renew_token_failed".tr,
          code: "renew_token_failed");
    }
  }

  /// restful post 操作
  Future raw_request(
    String path,
    String method, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    // TODO
    Log.warn("request start: $method $path ");
    if (query != null) {
      Log.warn("query: $query");
    }
    final response = await client.request(path, method,
        body: body, query: query, headers: headers);
    if (response.hasError) {
      throw formatError(response);
    } else {
      //
      try {
        JsonEncoder encoder = JsonEncoder.withIndent('  ');
        String prettyprint = encoder.convert(response.body);
        Log.verbose("response: $prettyprint");
      } catch (e) {
        Log.verbose("response: ${response.body}");
      }

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
    ApiOptions? options,
  }) async {
    headers = headers ?? {};
    options = options ?? ApiOptions();
    final config = AppConfig().config;
    final baseUrl = config.apiHost + config.apiPathPrefix;
    final fullUrl = baseUrl + path;
    String now = DateTime.now().toUtc().toIso8601String();
    if (options.withDefaultHeaders) {
      headers['x-client-date'] = now;
      headers['x-client-id'] = config.clientId;
      headers['x-client-version'] = config.version;
      headers['x-client-platform'] = Platform.isIOS ? 'iOS' : 'Android';
    }
    if (options.withSignature) {
      String queryString = Uri(queryParameters: query).query;
      headers['x-client-signature'] = getSignature(
          now: now,
          clientId: config.clientId,
          clientSecret: config.clientSecret,
          path: config.apiPathPrefix + path,
          method: method,
          query: queryString);
    }
    if (options.withAuthorization) {
      final authProvider = AuthProvider.to;
      final accessToken = authProvider.accessToken;
      if (accessToken != null) {
        headers['Authorization'] = "Bearer $accessToken";
      } else {
        // check refresh token if null
        if (authProvider.refreshToken != null) {
          // 续期token
          final token = await renewToken();
          // continue request
          headers['Authorization'] = "Bearer ${token.accessToken}";
        }
      }
    }

    try {
      final response = await raw_request(fullUrl, method,
          body: body, query: query, headers: headers);
      final responseBody = response.body;
      if (options.checkDataAttributes == true) {
        if (responseBody['data'] == null) {
          throw ServiceException.withCode("response_data_invalid".tr,
              code: "response_data_without_data");
        } else if (responseBody['data']['attributes'] == null) {
          throw ServiceException.withCode("response_data_invalid".tr,
              code: "response_data_without_data_attributes");
        }
      }
      return responseBody;
    } on ServiceException catch (e) {
      UIUtils.hideLoading();
      // await UIUtils.snackbar(e.title, e.detail);
      if (e.code == 'unauthorized_error' || e.status == 401) {
        await AuthProvider.to.cleanToken();
      }
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
    ApiOptions? options,
  }) async {
    options = options ?? ApiOptions();
    // get default check data attributes
    options.checkDataAttributes = options.checkDataAttributes ?? false;

    var response = await request(path, "GET",
        query: query, headers: headers, options: options);
    return response;
  }

  /// restful post 操作
  Future post(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    ApiOptions? options,
  }) async {
    var response = await request(path, "POST",
        body: body, query: query, headers: headers, options: options);
    return response;
  }

  Future put(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    ApiOptions? options,
  }) async {
    var response = await request(path, "PUT",
        body: body, query: query, headers: headers, options: options);
    return response;
  }

  Future patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    ApiOptions? options,
  }) async {
    var response = await request(path, "PATCH",
        body: body, query: query, headers: headers, options: options);
    return response;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    ApiOptions? options,
  }) async {
    var response = await request(path, "DELETE",
        body: body, query: query, headers: headers, options: options);
    return response;
  }
}

// 错误信息
formatError(Response response) {
  if (response.body != null) {
    // if string
    if (response.body is String) {
      return ServiceException.withCode("error_occured".tr,
          code: response.statusCode.toString(),
          detail: response.body,
          status: response.statusCode);
    }
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

    return ServiceException(title,
        code: code, detail: detail, status: statusCode);
  } else if (response.statusCode != null) {
    final statusCode = response.statusCode!;
    switch (statusCode) {
      case 400:
        return ServiceException.withCode("bad_request_error".tr,
            code: "bad_request", status: statusCode);
      case 401:
        return ServiceException.withCode("unauthorized_error".tr,
            code: "unauthorized_error", status: statusCode);
      case 403:
        return ServiceException.withCode("forbidden_error".tr,
            code: "forbidden_error", status: statusCode);
      case 404:
        return ServiceException.withCode("not_found_error".tr,
            code: "not_found_error", status: statusCode);
      case 405:
        return ServiceException.withCode("method_not_allowed_error".tr,
            code: "method_not_allowed_error", status: statusCode);
      case 500:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_500", status: statusCode);
      case 502:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_502", status: statusCode);
      case 503:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_503", status: statusCode);
      case 505:
        return ServiceException.withCode("server_internal_error".tr,
            code: "server_internal_error_505", status: statusCode);
      default:
        {
          return ServiceException.withCode("server_internal_error".tr,
              code: "server_internal_error_" + statusCode.toString(),
              status: statusCode);
        }
    }
  } else {
    return ServiceException.withCode("maybe_client_network_error".tr,
        code: "maybe_client_network_error", detail: response.statusText);
  }
}
