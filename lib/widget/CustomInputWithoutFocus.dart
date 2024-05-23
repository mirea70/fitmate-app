import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInputWithoutFocus extends StatelessWidget {
  const CustomInputWithoutFocus({required this.deviceSize, required this.onChangeMethod, required this.hintText, this.errorText, this.maxLength});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;
  final String hintText;
  final String? errorText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceSize.height * 0.08,
      width: deviceSize.width * 0.9,
      child: TextField(
        maxLength: maxLength,
        onChanged: onChangeMethod,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          errorText: errorText,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 15
          ),
          border: InputBorder.none,
        ),
        buildCounter: (
            BuildContext context,
            {
              required int currentLength,
              required int? maxLength,
              required bool isFocused
            }) => null,
      ),
    );
  }
}
