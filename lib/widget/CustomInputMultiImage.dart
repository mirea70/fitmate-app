
import 'package:fitmate_app/view_model/file/FileViewModel.dart';
import 'package:fitmate_app/view_model/mate/MateRegisterViewModel.dart';
import 'package:fitmate_app/widget/CustomAlert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CustomInputMultiImage extends ConsumerStatefulWidget {
  const CustomInputMultiImage({super.key, required this.deviceSize});

  final Size deviceSize;

  @override
  ConsumerState<CustomInputMultiImage> createState() =>
      _CustomInputMultiImageState();
}

class _CustomInputMultiImageState extends ConsumerState<CustomInputMultiImage> {

  void _showImageSourceSheet() {
    final fileViewModel = ref.read(fileViewModelProvider);
    final keepCount = ref.read(keepImageIdsProvider).length;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('카메라로 촬영'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (image != null) {
                    if (fileViewModel.files.length + keepCount + 1 > 3) {
                      showDialog(
                        context: this.context,
                        builder: (BuildContext context) {
                          return CustomAlert(
                            title: '최대 3개까지만 등록 가능합니다.',
                            deviceSize: widget.deviceSize,
                          );
                        },
                      );
                      return;
                    }
                    fileViewModel.addFile(image);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('갤러리에서 선택'),
                onTap: () async {
                  Navigator.pop(context);
                  final images = await ImagePicker().pickMultiImage();
                  if (fileViewModel.files.length + keepCount + images.length > 3) {
                    showDialog(
                      context: this.context,
                      builder: (BuildContext context) {
                        return CustomAlert(
                          title: '최대 3개까지만 등록 가능합니다.',
                          deviceSize: widget.deviceSize,
                        );
                      },
                    );
                    return;
                  }
                  if (images.isNotEmpty) fileViewModel.addFiles(images);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileViewModel = ref.watch(fileViewModelProvider);
    final keepImageIds = ref.watch(keepImageIdsProvider);
    int count = keepImageIds.length + fileViewModel.files.length;

    return Stack(
      children: [
        Container(
          height: 77,
          width: 77,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xffE8E8E8),
              width: 2,
            ),
          ),
        ),
        Positioned(
          top: 3,
          left: 15,
          child: Container(
            child: IconButton(
              onPressed: _showImageSourceSheet,
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
          height: widget.deviceSize.height * 0.01,
        ),
        Positioned(
          top: 45,
          left: 15,
          child: Text(
            '$count/3 (선택)',
            style: TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
