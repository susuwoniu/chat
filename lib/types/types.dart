library types;

import 'simple_account.dart';

export 'post.dart';
export 'postTemplates.dart';
export 'token.dart';
export 'account.dart';
export 'error.dart';
export 'message.dart';
export 'client.dart';
export 'room.dart';
export 'simple_account.dart';

class AccountMapResult {
  final Map<String, SimpleAccountEntity> accountMap;
  final List<String> indexes;
  final String? startCursor;
  final String? endCursor;

  AccountMapResult({
    this.indexes = const [],
    this.endCursor,
    this.startCursor,
    this.accountMap = const {},
  });
}
