import 'package:fitmate_app/error/CustomException.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  ErrorBoundary({required this.child});

  @override
  _ErrorBoundaryState createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return CustomAlert(
          title: errorMessage,
          deviceSize: MediaQuery.of(context).size
      );
    }

    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FlutterError.onError = (FlutterErrorDetails details) {
      if(details.exception is CustomException) {
        setState(() {
          hasError = true;
          errorMessage = details.toString();
        });
      }
      else {
        FlutterError.presentError(details);
      }
    };
  }

  @override
  void dispose() {
    // dispose 시 원래 에러 처리기로 복원
    FlutterError.onError = FlutterError.presentError;
    super.dispose();
  }
}