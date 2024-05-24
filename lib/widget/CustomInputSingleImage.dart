import 'dart:io';

import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CustomInputSingleImage extends ConsumerStatefulWidget {
  const CustomInputSingleImage({super.key, required this.deviceSize});

  final Size deviceSize;

  @override
  ConsumerState<CustomInputSingleImage> createState() =>
      _CustomInputSingleImageState();
}

class _CustomInputSingleImageState
    extends ConsumerState<CustomInputSingleImage> {
  @override
  Widget build(BuildContext context) {
    final fileViewModel = ref.watch(fileViewModelProvider);

    if (fileViewModel.exist()) {
      return Stack(
        children: [
          Container(
            height: widget.deviceSize.height * 0.1,
            width: widget.deviceSize.width * 0.25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: FileImage(
                  File(
                    fileViewModel.files[0].path,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 73,
            left: 77,
            child: Container(
              height: widget.deviceSize.height * 0.025,
              width: widget.deviceSize.width * 0.08,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffE8E8E8),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlert(
                        title: "등록된 이미지를 삭제하시겠습니까?",
                        deviceSize: widget.deviceSize,
                        action: () async {
                          XFile image = fileViewModel.files[0];
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
                  size: 20,
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
          SizedBox(
            height: widget.deviceSize.height * 0.11,
            width: widget.deviceSize.width * 0.28,
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            height: widget.deviceSize.height * 0.1,
            width: widget.deviceSize.width * 0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/default_profile.jpeg'),
              ),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 70,
            left: 70,
            child: Container(
              child: IconButton(
                onPressed: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) fileViewModel.addFile(image);
                },
                constraints: BoxConstraints(),
                icon: Icon(
                  Icons.add_a_photo,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
          SizedBox(
            height: widget.deviceSize.height * 0.12,
            width: widget.deviceSize.width * 0.27,
          ),
        ],
      );
    }
  }
}
