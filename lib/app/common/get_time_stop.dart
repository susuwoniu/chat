import 'package:chat/app/providers/account_provider.dart';
import 'package:chat/app/providers/auth_provider.dart';

getTimeStop() {
  final clientNow = DateTime.now().millisecondsSinceEpoch;

  final serverNow = clientNow - AccountProvider.to.diffTime;

  final next =
      DateTime.parse(AuthProvider.to.account.value.next_post_not_before)
          .millisecondsSinceEpoch;
  final nextCreateTime = (next - serverNow) / 1000;

  return nextCreateTime.toInt();
}
