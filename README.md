# chat

A new Flutter project.

## Getting Started

初始化环境请阅读： [CONTRIBUTION](CONTRIBUTION.md)

## Resources

- [GetX](https://github.com/jonataslaw/getx)
  - [GetCli](https://github.com/jonataslaw/get_cli)
  - [GetX状态管理中文文档](https://github.com/jonataslaw/getx/blob/master/documentation/zh_CN/state_management.md)
  - [GetX路由管理中文文档](https://github.com/jonataslaw/getx/blob/master/documentation/zh_CN/route_management.md)
- [Bilibili教程](https://space.bilibili.com/404904528/channel/detail?cid=177514&ctype=0)
- [Dart JSON and serialization](https://flutter.dev/docs/development/data-and-backend/json#code-generation)
- [Colors](https://coolors.co/palettes/trending)
- [Flutter Theme Generator Online](https://zeshuaro.github.io/flutter_theme/#/)
- [Open IM SDK](https://github.com/OpenIMSDK/Open-IM-SDK-Flutter)
- [flutter chat ui docs](https://docs.flyer.chat/flutter/chat-ui/advanced-usage)
- https://github.com/ducafecat/flutter_ducafecat_news_getx
- [uni_links](https://pub.dev/packages/uni_links)
- XMPP
  - <https://xmpp.org/extensions/xep-0430.html>
  - https://www.process-one.net/en/ejabberd/protocols/
  - https://mongooseim.readthedocs.io/en/4.0.1/user-guide/Features-and-supported-standards/
- Icons <https://fonts.google.com/icons?selected=Material+Icons>
## Tips

### 获取权限 

```dart
import 'package:permission_handler/permission_handler.dart';
import 'package:chat/app/ui_utils/permission_util.dart';


Map<Permission, PermissionStatus> statuses =
    await PermissionUtil.request([
  Permission.camera,
  Permission.storage,
  Permission.microphone,
  Permission.speech,
  Permission.location,
]);
// TODO reminder user
print("permission statuses: $statuses");
```

### 创建页面

```bash
get create page:home
```

### 生成Json类

```bash
make json
# 实际上执行 flutter pub run build_runner build 
```
## Official Resources

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 参考
- https://github.com/believeInJha/Bear_Log_In
- https://github.com/natintosh/intl_phone_number_input
- https://github.com/BrunoJurkovic/tcard
- https://github.com/best-flutter/flutter_swiper
- <div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>