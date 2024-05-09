import 'package:fitmate_app/view/homeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: FitMateApp(),
    ),
  );
}

class FitMateApp extends StatelessWidget {
  const FitMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      home: HomeView(),
    );
  }
}
