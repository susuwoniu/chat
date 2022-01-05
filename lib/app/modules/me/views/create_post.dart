// Widget createPost(
//       {required BuildContext context,
//       String? type,
//       String? id,
//       int? backgroundColorIndex}) {
//     final _width = MediaQuery.of(context).size.width;
//     final double paddingLeft = _width * 0.05;
//     final double paddingTop = _width * 0.04;

//     return GestureDetector(
//         onTap: () {
//           if (type != null) {
//             Get.toNamed(Routes.CREATE, arguments: {
//               "id": id,
//               "background-color-index": backgroundColorIndex
//             });
//           } else {
//             Get.toNamed(Routes.POST);
//           }
//         },
//         child: Container(
//           margin: EdgeInsets.fromLTRB(
//               paddingLeft, paddingTop, paddingLeft, paddingTop),
//           padding: EdgeInsets.all(_width * 0.03),
//           height: _width * 0.5,
//           width: _width * 0.4,
//           decoration: BoxDecoration(
//               color: Color(0xffe4e6ec), borderRadius: BorderRadius.circular(8)),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Icon(
//               Icons.add_circle_outline_rounded,
//               size: 52,
//               color: Colors.black54,
//             ),
//             SizedBox(height: 10),
//             Text("Create_Post",
//                 style: TextStyle(color: Colors.black54, fontSize: 16))
//           ]),
//         ));
//   }
