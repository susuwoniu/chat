import 'package:flutter/material.dart';
import 'package:chat/app/providers/providers.dart';

Widget Retry({
  String message = "出了点问题",
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
          message,
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
            children: [Icon(Icons.refresh), Text("刷新看看")],
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
