import 'dart:io';

import 'package:fitmate_app/view_model/FileViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CustomSingleInputImage extends ConsumerStatefulWidget {
  const CustomSingleInputImage({super.key, required this.deviceSize});

  final Size deviceSize;

  @override
  ConsumerState<CustomSingleInputImage> createState() =>
      _CustomSingleInputImageState();
}

class _CustomSingleInputImageState
    extends ConsumerState<CustomSingleInputImage> {
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
                color: Colors.grey,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                          '등록된 이미지를 삭제하시겠습니까?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                width: widget.deviceSize.width*0.05,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.orangeAccent,
                                  ),
                                  child: TextButton(
                                    onPressed: () async {
                                      XFile image = fileViewModel.files[0];
                                      fileViewModel.removeFile(image);
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
