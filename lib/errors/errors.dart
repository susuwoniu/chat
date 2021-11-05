class ServiceException implements Exception {
  final String detail;
  final String title;
  final String code;
  const ServiceException({
    required this.title,
    this.code = "unknow_service_exception",
    this.detail = "",
  });
  String toString() =>
      'ServiceException: code: $code, title:$title, detail: $detail';
}
