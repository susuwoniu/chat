import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:chat/types/types.dart';

class EditInfoController extends GetxController {
  static EditInfoController get to => Get.find();

  final count = 0.obs;
  final isAddImg = false.obs;
  final isShowDatePicked = false.obs;
  final _datePicked = DateTime.now().obs;
  DateTime get datePicked => _datePicked.value;

  final _imgList = RxList<String>([
    "https://img9.doubanio.com/icon/ul43630113-26.jpg",
    "https://i.loli.net/2021/11/24/If5SQkMWKl2rNvX.png",
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  ]);
  RxList<String> get imgList => _imgList;
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

  void addImg(int i) {}
  void deleteImg(int i) {
    imgList.removeAt(i);
  }

  void changeName(int i) {}
  void changeGender(int i) {}
  void changeBio(int i) {}
  void changeLocation(int i) {}
  void changeBirth(int i) {}
  void changeTags(int i) {}
  void setDatePicked(DateTime picked) {
    _datePicked.value = picked;
  }

  void setIsShowDatePicked(bool value) {
    isShowDatePicked.value = value;
  }
}
