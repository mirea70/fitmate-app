import 'dart:async';

import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountJoinAsyncViewModel extends AsyncNotifier<Account> {
  @override
  FutureOr<Account> build() async {
    return Future(() => Account.initial());
  }
}