import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({required this.deviceSize, required this.onTapMethod});
  final Size deviceSize;
  final GestureTapCallback onTapMethod;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMethod,
      child: Container(
        width: deviceSize.width * 0.9,
        height: deviceSize.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            '로그인',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
