import 'package:chat/app/providers/api_provider.dart';
import 'package:get/get.dart';
import 'package:chat/utils/upload.dart';
import 'package:chat/types/types.dart';

class ReportController extends GetxController {
  static ReportController get to => Get.find();
  final _related_post_id = Get.arguments['related_post_id'];
  final _related_account_id = Get.arguments['related_account_id'];
  final count = 0.obs;
  final reportType = ''.obs;
  final imgList = RxList([]);
  final isShowBlank = true.obs;
  ImageEntity? imgEntity;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void setReportType(String type) {
    reportType.value = type;
  }

  void setImgEntity(ImageEntity img) {
    imgEntity = img;
  }

  Future<ImageEntity> uploadImg(
      {required String path,
      required String mimeType,
      required double width,
      required double height,
      required int size}) async {
    final slot = await APIProvider.to.post("/file/image/slot", body: {
      "mime_type": mimeType,
      "size": size,
      "height": height,
      "width": width
    });
    // print(slot);
    final image = ImageEntity.fromJson(slot["meta"]["image"]);

    final putUrl = slot["meta"]["put_url"];
    final headers = slot["meta"]["headers"] as Map;
    final Map<String, String> newHeaders = {};

    for (var key in headers.keys) {
      newHeaders[key] = headers[key];
    }
    await upload(putUrl, path, headers: newHeaders, size: size);
    return image;
  }

  onPressReport({String? content}) async {
    final body = {};
    body['type'] = reportType.value;
    body['related_post_id'] = _related_post_id;
    body['related_account_id'] = _related_account_id;
    if (imgEntity != null) {
      body['images'] = [imgEntity!.toJson()];
    }
    if (content != '') {
      body['content'] = content;
    }
    await APIProvider.to.post('/report/reports', body: body);
  }
}
