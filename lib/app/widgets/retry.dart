import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget Retry({
  String message = "something_went_wrong",
  required Function onRetry,
}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.error_outline, size: 50),
        SizedBox(
          height: 20,
        ),
        Text(
          message.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh),
              SizedBox(
                width: 4,
              ),
              Text("refresh".tr)
            ],
          ),
          onPressed: () async {
            onRetry();
            // TODO
            // await CacheProvider.to.clear();
            // await AccountStoreProvider.to.clear();
            // await KVProvider.to.clear();
            // await SimpleAccountMapCacheProvider.to.clear();
          },
        ),
      ],
    ),
  );
}
