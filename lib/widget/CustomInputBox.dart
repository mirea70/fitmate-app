import 'package:flutter/material.dart';

class CustomInputBox extends StatelessWidget {
  CustomInputBox({required this.onTap, required this.title, this.selectNum = 0, required this.deviceSize, required this.imagePath, required this.index});

  final onTap;
  final int selectNum;
  final Size deviceSize;
  final String imagePath;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectNum == index ? Colors.orangeAccent : Colors.grey,
            width: 5,
          ),
        ),
        height: deviceSize.height * 0.15,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: deviceSize.width*0.02),
              height: deviceSize.height * 0.08,
              width: deviceSize.width*0.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              width: deviceSize.width*0.06,
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
