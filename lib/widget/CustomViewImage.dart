import 'dart:io';

import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomViewImage extends StatelessWidget {
  const CustomViewImage({super.key, required this.deviceSize, required this.index, required this.fileViewModel});

  final FileViewModel fileViewModel;
  final Size deviceSize;
  final int index;


  @override
  Widget build(BuildContext context) {
    // final fileViewModel = ref.watch(fileViewModelProvider);
    final double boxSize = deviceSize.width * 0.2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: boxSize,
          width: boxSize,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
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
          top: -5,
          right: -5,
          child: GestureDetector(
            onTap: () {
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
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
