import 'package:get/get.dart';
import 'package:chat/utils/upload.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class EditInfoController extends GetxController {
  static EditInfoController get to => Get.find();
  final birthday = ''.obs;
  final count = 0.obs;
  final isAddImg = false.obs;
  final isShowDatePicked = false.obs;
  final _datePicked = DateTime.now().toString().obs;
  String get datePicked => _datePicked.value;

  final isChangedName = false.obs;
  final isChangedGender = false.obs;
  final isChangedBio = false.obs;
  final isChangedLocation = false.obs;
  final isChangedBirth = false.obs;
  final isChangedTags = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  void setIsAddImg() {
    isAddImg.value = true;
  }

  Future<void> addImg(
    int i,
    ProfileImageEntity img,
  ) async {
    final accountEntity = AuthProvider.to.account.value;
    final List<ProfileImageEntity> imgList = [...accountEntity.profile_images];
    if (imgList.length > i) {
      imgList[i] = img;
    } else {
      imgList.add(img);
    }
    AuthProvider.to.account.update((value) {
      if (value != null) {
        value.profile_images = imgList;
      }
    });
    final newAccountEntity = AuthProvider.to.account.value;
    await AuthProvider.to.saveAccount(newAccountEntity);
  }

  Future<void> deleteImg(int i) async {
    // TODO
    final account = AuthProvider.to.account;
    account.update((val) {
      val!.profile_images.removeAt(i);
    });
    // save account
    await AuthProvider.to.saveAccount(account.value);
    // put new profiles
    await APIProvider.to.put("/account/me/profile-images",
        body: {"images": account.value.profile_images});
  }

  void changeLocation(int i) {}
  void changeBirth(String value) {
    birthday.value = value;
  }

  void setNewDate(DateTime picked) {
    final _picked = picked.toString().substring(0, 10);
    _datePicked.value = _picked;
  }

  void setIsShowYearPicked(bool value) {
    isShowDatePicked.value = value;
  }

  sendProfileImage(ProfileImageEntity img, {required int index}) async {
    final slot =
        await APIProvider.to.post("/account/me/profile-images/slot", body: {
      "mime_type": img.mime_type,
      "size": img.size,
      "height": img.height,
      "width": img.width
    });
    // print(slot);
    final putUrl = slot["meta"]["put_url"];
    final getUrl = slot["meta"]["get_url"];
    final headers = slot["meta"]["headers"] as Map;
    final Map<String, String> newHeaders = {};

    for (var key in headers.keys) {
      newHeaders[key] = headers[key];
    }
    await upload(putUrl, img.url, headers: newHeaders, size: img.size);
    final result =
        await APIProvider.to.put('/account/me/profile-images/$index', body: {
      "url": getUrl,
      "width": img.width,
      "height": img.height,
      "size": img.size,
      "mime_type": img.mime_type
    });

    final newImage = ProfileImageEntity.fromJson(result['data']['attributes']);

    // save the latest image info
    await addImg(index, newImage);
    // TODO hide loading
  }
}
