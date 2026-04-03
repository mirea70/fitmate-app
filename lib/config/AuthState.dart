import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

final authStatusProvider = NotifierProvider<AuthStatusNotifier, AuthStatus>(
  () => AuthStatusNotifier(),
);

class AuthStatusNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() => AuthStatus.unknown;
}
