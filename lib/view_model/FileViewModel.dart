import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final fileViewModelProvider = ChangeNotifierProvider<FileViewModel>(
    (ref) => FileViewModel());

class FileViewModel extends ChangeNotifier {

  List<XFile> files = [];

  void addFile(XFile file) {
    files.add(file);
    notifyListeners();
  }

  void removeFile(XFile file) {
    files.remove(file);
    notifyListeners();
  }

  bool exist() {
    return !files.isEmpty;
  }

  // 메이트 소개 이미지용
  bool isOver() {
    if(files.length >= 3) return true;
    else return false;
  }
}