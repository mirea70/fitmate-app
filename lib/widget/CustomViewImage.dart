import 'dart:io';

import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CustomViewImage extends StatelessWidget {
  const CustomViewImage({super.key, required this.deviceSize, required this.index, required this.fileViewModel});

  final FileViewModel fileViewModel;
  final Size deviceSize;
  final int index;


  @override
  Widget build(BuildContext context) {
    // final fileViewModel = ref.watch(fileViewModelProvider);
    return Stack(
      children: [
        Container(
          height: deviceSize.height * 0.09,
          width: deviceSize.width * 0.2,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: FileImage(
                File(
                  fileViewModel.files[index].path,
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xffE8E8E8),
              width: 2,
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 57,
          child: Container(
            height: deviceSize.height * 0.02,
            width: deviceSize.width * 0.05,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlert(
                      title: "등록된 이미지를 삭제하시겠습니까?",
                      deviceSize: deviceSize,
                      action: () async {
                        XFile image = fileViewModel.files[index];
                        fileViewModel.removeFile(image);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 10,
              ),
              alignment: Alignment.center,
            ),
          ),
        ),
      ],
    );
  }
}
