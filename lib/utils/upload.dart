import 'package:http/http.dart';
import 'dart:io';
import 'dart:async';

Future<void> upload(String putUrl, String path,
    {required Map<String, String> headers, required int size}) async {
  final stream = StreamedRequest('PUT', Uri.parse(putUrl));
  stream.headers.addAll(headers);
  final file = File(path);
  stream.contentLength = size;
  file.openRead().listen((chunk) {
    stream.sink.add(chunk);
  }, onDone: () {
    stream.sink.close();
  });

  final response = await stream.send();
  if (response.statusCode == 200 || response.statusCode == 201) {
    return;
  }
  throw Exception('Can not upload now');
}
