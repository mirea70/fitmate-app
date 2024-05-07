import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(this.title, this.view);
  final StatelessWidget view;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => view),
        );
      },
      child: Text(
        title,
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: 12,
        ),
      ),
    );
  }
}
