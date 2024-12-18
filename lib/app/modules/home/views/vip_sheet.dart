import 'package:chat/app/modules/complete_age/views/next_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../me/views/dots_widget.dart';
import '../../complete_age/views/next_button.dart';
import 'package:chat/common.dart';

final List<Map<String, dynamic>> _cardList = [
  {
    'icon': Icons.star_rounded,
    'title': 'special_icon'.tr,
    'detail': 'display-specific_logo'.tr
  },
  {
    'icon': Icons.pets_outlined,
    'title': 'view_likes'.tr,
    'detail': 'see_who_liked_me'.tr
  },
  {
    'icon': Icons.auto_fix_high_outlined,
    'title': 'Polish'.tr,
    'detail': 'your_post_will_be_pushed_to_the_latest'.tr
  },
  {
    'icon': Icons.filter_list_rounded,
    'title': 'Filter'.tr,
    'detail': 'choose_persons_you_are_interested_in'.tr
  },
  {
    'icon': Icons.timer_off_rounded,
    'title': 'unlimited_posts'.tr,
    'detail': 'get_unlimited_posts'.tr
  },
  {
    'icon': Icons.star_outlined,
    'title': 'unlimited_favorites'.tr,
    'detail': 'get_unlimited_favorites'.tr
  },
  {
    'icon': Icons.more_horiz_rounded,
    'title': 'more_features'.tr,
    'detail': 'we_will_develop_more_membership_features'.tr
  }
];

class VipSheet extends StatefulWidget {
  final BuildContext context;
  final int? selectedPriceIndex;
  final int? index;
  VipSheet({
    Key? key,
    required this.context,
    this.selectedPriceIndex,
    this.index,
  });
  @override
  _VipSheetState createState() => _VipSheetState();
}

class _VipSheetState extends State<VipSheet> {
  final CarouselController buttonCarouselController = CarouselController();
  late int selectedPriceIndex;
  var _current = 0;

  @override
  void initState() {
    super.initState();
    selectedPriceIndex = 0;
    _current = widget.index ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    // final _account = AuthProvider.to.account.value;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Wrap(alignment: WrapAlignment.center, children: [
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 4,
            blurRadius: 7,
            offset: Offset(0, 2), // changes position of shadow
          )
        ]),
        margin: EdgeInsets.only(bottom: height * 0.2),
        width: width * 0.9,
        child: Column(children: [
          Container(
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              CarouselSlider(
                items: _cardList
                    .map((item) => VipCard(
                        context: context,
                        icon: item['icon'],
                        title: item['title'],
                        detail: item['detail']))
                    .toList(),
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                    initialPage: widget.index ?? 0,
                    autoPlayInterval: const Duration(seconds: 3),
                    height: height * 0.25,
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.close_outlined,
                        size: 26,
                        color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () {
                      Get.back();
                    },
                  )),
              Positioned(
                bottom: 10,
                child: DotsWidget(
                    current: _current,
                    onTap: buttonCarouselController.animateToPage,
                    count: _cardList.length,
                    size: 9),
              )
            ]),
          ),
          _priceList(context: context),
          _toBuyButton(),
        ]),
      )
    ]);
  }

  Widget VipCard(
      {required BuildContext context,
      required IconData icon,
      required String title,
      required String detail}) {
    final double height = MediaQuery.of(context).size.height * 0.25;
    final double width = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple,
                Colors.blue.shade800,
              ]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.onPrimary),
              child: Icon(icon,
                  size: 26, color: Theme.of(context).colorScheme.primary)),
          SizedBox(height: 10),
          Text(title,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimary)),
          SizedBox(height: 5),
          Text(detail,
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onPrimary)),
          SizedBox(height: 20),
        ]));
  }

  Widget _toBuyButton() {
    return Container(
      child: NextButton(text: 'To_Purchase'.tr, onPressed: () {}),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
    );
  }

  Widget _priceList({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
        color: Theme.of(context).colorScheme.surface,
        height: height * 0.2,
        width: width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          _price(
              width: width * 0.23, time: '1_week'.tr, price: 5, priceIndex: 0),
          _price(
              width: width * 0.23,
              time: '1_month'.tr,
              price: 10,
              priceIndex: 1),
          _price(
              width: width * 0.23,
              time: '3_months'.tr,
              price: 20,
              priceIndex: 2),
          _price(
              width: width * 0.23,
              time: '6_months'.tr,
              price: 30,
              priceIndex: 3),
          _price(
              width: width * 0.23, time: '1_year'.tr, price: 50, priceIndex: 4),
        ]));
  }

  Widget _price(
      {required double width,
      required String time,
      required int price,
      required int priceIndex}) {
    final isSelected = selectedPriceIndex == priceIndex;
    return GestureDetector(
        onTap: () {
          setState(() {
            selectedPriceIndex = priceIndex;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 7, vertical: 25),
          padding: EdgeInsets.symmetric(horizontal: 2),
          width: width,
          decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : ChatThemeData.secondaryBlack,
                  width: 2),
              borderRadius: BorderRadius.circular(8)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(time,
                style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : ChatThemeData.secondaryBlack)),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('¥',
                  style: TextStyle(
                      fontSize: 15,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Colors.grey.shade800)),
              Text(price.toString(),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : ChatThemeData.secondaryBlack)),
            ]),
          ]),
        ));
  }
}
