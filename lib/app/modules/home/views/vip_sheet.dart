import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:chat/app/providers/providers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../me/views/dots_widget.dart';

// class VipCardEntity {
//   final IconData icon;
//   final String title;
//   final String detail;

//   VipCardEntity(
//       {required this.icon, required this.title, required this.detail});
// }

final List<Map<String, dynamic>> _cardList = [
  {
    'icon': Icons.star_border_purple500_rounded,
    'title': '会员标识',
    'detail': '展示会员专属标识'
  },
  {'icon': Icons.catching_pokemon_rounded, 'title': '查看访客', 'detail': '查看主页访客'},
  {'icon': Icons.theater_comedy_rounded, 'title': '匿名访问', 'detail': '适度隐藏自己'},
  {'icon': Icons.filter_list_rounded, 'title': '设置筛选', 'detail': '筛选性别/年龄/距离'},
  {'icon': Icons.timer_off_rounded, 'title': '无限发帖', 'detail': '解锁发帖无时间限制模式'},
  {'icon': Icons.shortcut_rounded, 'title': '更多特权', 'detail': '更多会员功能敬请期待...'}
];

class VipSheet extends StatefulWidget {
  final BuildContext context;
  const VipSheet({Key? key, required this.context});
  @override
  _VipSheetState createState() => _VipSheetState();
}

class _VipSheetState extends State<VipSheet> {
  void initState() {
    super.initState();
  }

  final _current = 0.obs;
  int get current => _current.value;
  final CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    final _account = AuthProvider.to.account.value;
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
                    autoPlayInterval: const Duration(seconds: 3),
                    height: height * 0.25,
                    autoPlay: true,
                    viewportFraction: 1,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current.value = index;
                      });
                    }),
              ),
              Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.close_outlined,
                        size: 26, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    },
                  )),
              Positioned(
                bottom: 10,
                child: Obx(() => DotsWidget(
                    current: _current.value,
                    onTap: buttonCarouselController.animateToPage,
                    count: _cardList.length,
                    size: 9)),
              )
            ]),
          ),
          _priceList(context: context),
          _buyButton(height: height, width: width)
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
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purple, Colors.blue.shade700]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Icon(icon, size: 26, color: Colors.purple.shade300)),
          SizedBox(height: 10),
          Text(title,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 5),
          Text(detail, style: TextStyle(fontSize: 14, color: Colors.white)),
          SizedBox(height: 20),
        ]));
  }

  Widget _buyButton({required double height, required double width}) {
    return Container(
      child: GestureDetector(
        child: Container(
            alignment: Alignment.center,
            height: height * 0.15,
            width: width * 0.8,
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(8)),
            child: Text('To_Purchase',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17))),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 15),
      height: height * 0.1,
      width: width * 0.9,
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
    );
  }

  Widget _priceList({required BuildContext context}) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
        color: Colors.grey.shade300,
        height: height * 0.2,
        width: width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(scrollDirection: Axis.horizontal, children: [
          _price(width: width * 0.23, time: '1_week', price: 5),
          _price(width: width * 0.23, time: '1_month', price: 10),
          _price(width: width * 0.23, time: '3_months', price: 20),
          _price(width: width * 0.23, time: '6_months', price: 30),
          _price(width: width * 0.23, time: '1_year', price: 50),
        ]));
  }

  Widget _price(
      {required double width, required String time, required int price}) {
    return GestureDetector(
        onTap: () {
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          padding: EdgeInsets.symmetric(horizontal: 2),
          width: width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade900, width: 2),
              borderRadius: BorderRadius.circular(8)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(time,
                style: TextStyle(fontSize: 17, color: Colors.grey.shade900)),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('¥',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
              Text(price.toString(),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ]),
          ]),
        ));
  }
}
