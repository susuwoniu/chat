import 'package:chat/app/providers/providers.dart';

toggleBlock({required String id, required bool toBlocked}) async {
  // block im
  if (toBlocked) {
    await ChatProvider.to.roomManager!.blockUser("$id@xmpp.scuinfo.com");
  } else {
    await ChatProvider.to.roomManager!.unblockUser("$id@xmpp.scuinfo.com");
  }
  await APIProvider.to.patch("/account/accounts/$id", body: {
    "block_count_action": toBlocked ? 'increase_one' : 'decrease_one'
  });
}
