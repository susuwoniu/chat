import "package:get/get.dart";

class ServiceException implements Exception {
  final String detail;
  final String title;
  final String code;
  const ServiceException(this.title,
      {this.code = "unknow_service_exception", this.detail = ""});
  static ServiceException withCode(String title,
      {String code = "unknow_service_exception", detail = ""}) {
    var finalDetail = detail;
    if (detail.isEmpty) {
      finalDetail = "请稍后再试！ [错误码: $code]";
    } else {
      finalDetail = "$detail [错误码: $code]";
    }
    return ServiceException(title, code: code, detail: finalDetail);
  }

  static ServiceException unknow() {
    return ServiceException("unknow_error".tr,
        code: "unknow_error", detail: "unknow_error".tr);
  }

  static ServiceException unknow_with_message(String message) {
    return ServiceException("unknow_error".tr,
        code: "unknow_error", detail: message);
  }

  @override
  String toString() =>
      'ServiceException: code: $code, title:$title, detail: $detail';
}
