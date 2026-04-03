import 'package:fitmate_app/config/AppConfig.dart';
import 'package:fitmate_app/config/AuthState.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/view/homeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await AppConfig.initialize();
  runApp(
    ProviderScope(
      child: const FitMateApp(),
    ),
  );
}

class FitMateApp extends ConsumerWidget {
  const FitMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);

    ref.listen<AuthStatus>(authStatusProvider, (prev, next) {
      if (next == AuthStatus.unauthenticated) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeView()),
          (route) => false,
        );
      }
    });

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      home: HomeView(),
    );
  }
}
