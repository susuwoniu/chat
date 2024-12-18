import 'package:get/get.dart';
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
    ImageEntity img,
  ) async {
    final accountEntity = AuthProvider.to.account.value;
    final List<ImageEntity> imgList = [...accountEntity.profile_images];
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

  // Future<void> deleteImg(int i) async {
  //   // TODO
  //   final account = AuthProvider.to.account;
  //   account.update((val) {
  //     val!.profile_images.removeAt(i);
  //   });
  //   // save account
  //   await AuthProvider.to.saveAccount(account.value);
  //   // put new profiles
  //   await APIProvider.to.put("/account/me/profile-images",
  //       body: {"images": account.value.profile_images});
  // }

  void changeLocation(int i) {}
  void changeBirth(String value) {
    birthday.value = value;
  }

  void setNewDate(DateTime picked) {
    final _picked = picked.toString().substring(0, 10);
    _datePicked.value = _picked;
  }
}
