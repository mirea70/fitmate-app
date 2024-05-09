import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({required this.deviceSize, required this.onTapMethod, required this.title, this.isEnabled = true});

  final Size deviceSize;
  final VoidCallback onTapMethod;
  final String title;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceSize.width * 0.9,
      height: deviceSize.height * 0.07,
      child: ElevatedButton(
        onPressed: isEnabled ? onTapMethod : null,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: Colors.orangeAccent,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
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
