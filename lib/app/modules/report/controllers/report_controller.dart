import 'package:chat/app/providers/api_provider.dart';
import 'package:chat/app/ui_utils/ui_utils.dart';
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

  uploadImg({ImageEntity? img}) async {
    if (img != null) {
      final slot = await APIProvider.to.post("/file/image/slot", body: {
        "mime_type": img.mime_type,
        "size": img.size,
        "height": img.height,
        "width": img.width
      });
      // print(slot);
      final putUrl = slot["meta"]["put_url"];
      final headers = slot["meta"]["headers"] as Map;
      final Map<String, String> newHeaders = {};

      for (var key in headers.keys) {
        newHeaders[key] = headers[key];
      }
      await upload(putUrl, img.url, headers: newHeaders, size: img.size);
    }
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
