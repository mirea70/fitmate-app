import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.deviceSize, required this.onTapMethod,
    required this.title, this.isEnabled = false,
    this.color = Colors.orangeAccent, this.textColor = Colors.white});

  final Size deviceSize;
  final VoidCallback onTapMethod;
  final String title;
  final bool isEnabled;
  final Color color;
  final Color textColor;

@override
  Widget build(BuildContext context) {
    return Container(
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.06,
      child: ElevatedButton(
        onPressed: isEnabled ? onTapMethod : null,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: color,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
