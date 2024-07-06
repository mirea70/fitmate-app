import 'package:fitmate_app/view/homeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();
  runApp(
    ProviderScope(
      child: const FitMateApp(),
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
