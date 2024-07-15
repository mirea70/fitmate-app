import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInputWithoutFocus extends StatefulWidget {
  const CustomInputWithoutFocus({
        required this.deviceSize,
        this.onChangeMethod,
        required this.hintText,
        this.errorText,
        this.maxLength,
        this.onSubmitted,
        this.initText,
      });
  final Size deviceSize;
  final ValueChanged<String>? onChangeMethod;
  final String hintText;
  final String? errorText;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;
  final String? initText;

  @override
  State<CustomInputWithoutFocus> createState() => _CustomInputWithoutFocusState();
}

class _CustomInputWithoutFocusState extends State<CustomInputWithoutFocus> {
  late TextEditingController _controller;
  String? _initText;

  void initState() {
    super.initState();
    _initText = widget.initText;
    print(_initText);
    _controller = TextEditingController(text: _initText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.deviceSize.height * 0.08,
      width: widget.deviceSize.width * 0.9,
      alignment: Alignment.center,
      child: TextField(
        controller: _controller,
        maxLength: widget.maxLength,
        onChanged: widget.onChangeMethod,
        onSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          errorText: widget.errorText,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 16
          ),
          border: InputBorder.none,
          isDense: true,
        ),
        buildCounter: (
            BuildContext context,
            {
              required int currentLength,
              required int? maxLength,
              required bool isFocused
            }) => null,
      ),
    );
  }
}
