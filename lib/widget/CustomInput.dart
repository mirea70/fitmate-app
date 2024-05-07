import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({required this.deviceSize, required this.onChangeMethod});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceSize.height * 0.08,
      width: deviceSize.width * 0.9,
      child: TextField(
        onChanged: onChangeMethod,
        decoration: InputDecoration(
          labelText: '아이디를 입력해주세요.',
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }
}
