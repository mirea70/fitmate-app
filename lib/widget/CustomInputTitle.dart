import 'package:flutter/material.dart';

class CustomInputTitle extends StatelessWidget {
  const CustomInputTitle(String this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
      ),
    );
  }
}
