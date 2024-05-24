import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({required this.deviceSize, required this.onChangeMethod, required this.hintText, this.errorText, this.maxLength, required this.text});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;
  final String hintText;
  final String? errorText;
  final int? maxLength;
  final String text;

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant CustomInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _textController.text = widget.text;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.deviceSize.height * 0.08,
      width: widget.deviceSize.width * 0.9,
      child: TextField(
        controller: _textController,
        maxLength: widget.maxLength,
        onChanged: widget.onChangeMethod,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          errorText: widget.errorText,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 17
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xffE8E8E8), width: 2.0),
          ),
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
