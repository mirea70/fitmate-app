import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({required this.deviceSize, required this.onChangeMethod, required this.hintText, this.errorText, this.maxLength});
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
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          errorText: errorText,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 17
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 2.0),
          ),
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
