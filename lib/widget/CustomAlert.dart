import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {

  final String title;
  final String? content;
  final Size deviceSize;
  final VoidCallback? action;

  const CustomAlert({required this.title, this.content, required this.deviceSize, this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 17
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: deviceSize.height*0.01,
          ),
          if(content != null)
          Text(
            content!,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 13
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(action != null)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orangeAccent,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: deviceSize.width*0.05,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orangeAccent,
                ),
                child: TextButton(
                  onPressed: action != null ? action
                      : (){
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
