// import 'dart:async';
// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart' hide FormData;
// import 'package:chat/constants/constants.dart';
// import 'package:chat/app/ui_utils/ui_utils.dart';
// import 'package:chat/errors/errors.dart';

// /*
//   * http 操作类
//   *
//   * 手册
//   * https://github.com/flutterchina/dio/blob/master/README-ZH.md
//   *
//   * 从 3 升级到 4
//   * https://github.com/flutterchina/dio/blob/master/migration_to_4.x.md
// */
// class APIProvider {
//   static APIProvider instance = APIProvider._internal();
//   factory APIProvider() => instance;

//   late Dio dio;
//   CancelToken cancelToken = CancelToken();

//   APIProvider._internal() {
//     // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
//     BaseOptions options = BaseOptions(
//       // 请求基地址,可以包含子路径
//       baseUrl: API_PREFIX,

//       // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
//       //连接服务器超时时间，单位是毫秒.
//       connectTimeout: 10000,

//       // 响应流上前后两次接受到数据的间隔，单位为毫秒。
//       receiveTimeout: 5000,

//       // Http请求头.
//       headers: {},

//       /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
//       /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
//       /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
//       /// 就会自动编码请求体.
//       contentType: 'application/json; charset=utf-8',

//       /// [responseType] 表示期望以那种格式(方式)接受响应数据。
//       /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
//       ///
//       /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
//       /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
//       ///
//       /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
//       responseType: ResponseType.json,
//     );

//     dio = Dio(options);

//     GetConnect getClient = GetConnect();

//     // 添加拦截器
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         // Do something before request is sent
//         return handler.next(options); //continue
//         // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
//         // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
//         //
//         // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
//         // 这样请求将被中止并触发异常，上层catchError会被调用。
//       },
//       onResponse: (response, handler) {
//         // Do something with response data
//         return handler.next(response); // continue
//         // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
//         // 这样请求将被中止并触发异常，上层catchError会被调用。
//       },
//     ));
//   }

//   /*
//    * error统一处理
//    */

//   // 错误信息
//   formatError(DioError error) {
//     switch (error.type) {
//       case DioErrorType.cancel:
//         return ServiceException.withCode('request_cancel'.tr,
//             code: 'request_cancel');
//       case DioErrorType.connectTimeout:
//         return ServiceException.withCode('request_timeout'.tr,
//             code: 'connect_timeout');

//       case DioErrorType.sendTimeout:
//         return ServiceException.withCode('request_timeout'.tr,
//             code: 'send_timeout');
//       case DioErrorType.receiveTimeout:
//         return ServiceException.withCode('receive_timeout'.tr,
//             code: 'receive_timeout');

//       case DioErrorType.response:
//         {
//           if (error.response?.data != null) {
//             final data = error.response!.data!;
//             final statusCode = error.response!.statusCode!;
//             String title, code, detail;
//             if (data.containsKey("errors") && data["errors"].length > 0) {
//               final error = data["errors"][0];
//               title = error["title"];
//               code = error["code"];
//               detail = error["detail"];
//             } else {
//               title = "unknow_error_title".tr;
//               code = statusCode.toString();
//               detail = error.response!.statusMessage ?? '';
//             }

//             return ServiceException.withCode(title, code: code, detail: detail);
//           } else if (error.response?.statusCode != null) {
//             final statusCode = error.response!.statusCode!;
//             switch (statusCode) {
//               case 400:
//                 return ServiceException.withCode("bad_request_error".tr,
//                     code: "bad_request");
//               case 401:
//                 return ServiceException.withCode("unauthorized_error".tr,
//                     code: "unauthorized_error");
//               case 403:
//                 return ServiceException.withCode("forbidden_error".tr,
//                     code: "forbidden_error");
//               case 404:
//                 return ServiceException.withCode("not_found_error".tr,
//                     code: "not_found_error");
//               case 405:
//                 return ServiceException.withCode("method_not_allowed_error".tr,
//                     code: "method_not_allowed_error");
//               case 500:
//                 return ServiceException.withCode("server_internal_error".tr,
//                     code: "server_internal_error_500");
//               case 502:
//                 return ServiceException.withCode("server_internal_error".tr,
//                     code: "server_internal_error_502");
//               case 503:
//                 return ServiceException.withCode("server_internal_error".tr,
//                     code: "server_internal_error_503");
//               case 505:
//                 return ServiceException.withCode("server_internal_error".tr,
//                     code: "server_internal_error_505");
//               default:
//                 {
//                   return ServiceException.withCode("server_internal_error".tr,
//                       code: "server_internal_error_" + statusCode.toString());
//                 }
//             }
//           }
//         }
//         break;
//       default:
//         {
//           return ServiceException.unknow();
//         }
//     }
//   }

//   /*
//    * 取消请求
//    *
//    * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
//    * 所以参数可选
//    */
//   void cancelRequests(CancelToken token) {
//     token.cancel("cancelled");
//   }

//   /// 读取本地配置
//   Map<String, dynamic>? getAuthorizationHeader() {
//     var headers = <String, dynamic>{};
//     // if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
//     //   headers['Authorization'] = 'Bearer ${UserStore.to.token}';
//     // }
//     return headers;
//   }

//   /// restful post 操作
//   Future raw_request(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     try {
//       final response = await dio.request(path,
//           data: data, queryParameters: queryParameters, options: options);
//       return response;
//     } on DioError catch (e) {
//       throw formatError(e);
//     } catch (e) {
//       throw ServiceException.unknow_with_message(e.toString());
//     }
//   }

//   /// restful request 操作
//   Future request(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     Map<String, dynamic>? authorization = getAuthorizationHeader();
//     if (authorization != null) {
//       requestOptions.headers!.addAll(authorization);
//     }
//     try {
//       final response = await raw_request(path,
//           data: data,
//           queryParameters: queryParameters,
//           options: requestOptions);
//       return response.data;
//     } on ServiceException catch (e) {
//       await UIUtils.snackbar(e.title, e.detail);
//       rethrow;
//     }
//   }

//   /// restful get 操作
//   /// refresh 是否下拉刷新 默认 false
//   /// noCache 是否不缓存 默认 true
//   /// list 是否列表 默认 false
//   /// cacheKey 缓存key
//   /// cacheDisk 是否磁盘缓存
//   Future get(
//     String path, {
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//     bool refresh = false,
//     bool noCache = !CACHE_ENABLE,
//     bool list = false,
//     String cacheKey = '',
//     bool cacheDisk = false,
//   }) async {
//     Options requestOptions = options ?? Options();

//     requestOptions.extra = requestOptions.extra ?? <String, dynamic>{};

//     requestOptions.extra!.addAll({
//       "refresh": refresh,
//       "noCache": noCache,
//       "list": list,
//       "cacheKey": cacheKey,
//       "cacheDisk": cacheDisk,
//     });
//     requestOptions.method = "GET";

//     var response = await request(
//       path,
//       queryParameters: queryParameters,
//       options: options,
//     );
//     return response.data;
//   }

//   /// restful post 操作
//   Future post(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.headers = requestOptions.headers ?? {};
//     requestOptions.method = "POST";
//     var response = await request(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//     );
//     return response.data;
//   }

//   /// restful put 操作
//   Future put(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.method = "PUT";
//     var response = await request(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//     );
//     return response.data;
//   }

//   /// restful patch 操作
//   Future patch(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.method = "PATCH";
//     var response = await request(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//     );
//     return response.data;
//   }

//   /// restful delete 操作
//   Future delete(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.method = "DELETE";

//     var response = await request(
//       path,
//       data: data,
//       queryParameters: queryParameters,
//       options: requestOptions,
//     );
//     return response.data;
//   }

//   /// restful post form 表单提交操作
//   Future postForm(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.method = "POST";
//     var response = await request(
//       path,
//       data: FormData.fromMap(data),
//       queryParameters: queryParameters,
//       options: requestOptions,
//     );
//     return response.data;
//   }

//   /// restful post Stream 流数据
//   Future postStream(
//     String path, {
//     dynamic data,
//     int dataLength = 0,
//     Map<String, dynamic>? queryParameters,
//     Options? options,
//   }) async {
//     Options requestOptions = options ?? Options();
//     requestOptions.method = "POST";

//     var response = await request(
//       path,
//       data: Stream.fromIterable(data.map((e) => [e])),
//       queryParameters: queryParameters,
//       options: requestOptions,
//     );
//     return response.data;
//   }
// }
