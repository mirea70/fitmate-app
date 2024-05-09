import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInputWithButton extends StatelessWidget {
  const CustomInputWithButton({required this.deviceSize, required this.onChangeMethod,
    required this.hintText, this.errorText, required this.onPressMethod});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;
  final VoidCallback onPressMethod;
  final String hintText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceSize.height * 0.08,
      width: deviceSize.width * 0.9,
      child: TextField(
        onChanged: onChangeMethod,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
          errorText: errorText,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 15
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          suffix: ElevatedButton(
            onPressed: onPressMethod,
            child: Text(
              '인증요청',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ),
      ),
    );
  }
}