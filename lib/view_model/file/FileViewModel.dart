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

  void addFiles(List<XFile> files) {
    this.files.addAll(files);
    notifyListeners();
  }

  void removeFile(XFile file) {
    this.files.remove(file);
    notifyListeners();
  }

  bool exist() {
    return !this.files.isEmpty;
  }

  // 메이트 소개 이미지용
  bool isOver(List<XFile> newFiles) {
    if(files.length + newFiles.length > 3) return true;
    else return false;
  }

  void reset() {
    this.files = [];
    notifyListeners();
  }
}