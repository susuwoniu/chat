class ApiEntity {
  /// The generated code assumes these values exist in JSON.
  final String host, prefix;
  ApiEntity({required String apiPrefix})
      : host = Uri.parse(apiPrefix).scheme + "//" + Uri.parse(apiPrefix).host,
        prefix = Uri.parse(apiPrefix).path;
}
