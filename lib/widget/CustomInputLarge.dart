import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInputLarge extends StatefulWidget {
  const CustomInputLarge({required this.deviceSize, required this.onChangeMethod, required this.hintText, this.errorText, this.maxLength, required this.text});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;
  final String hintText;
  final String? errorText;
  final int? maxLength;
  final String text;

  @override
  State<CustomInputLarge> createState() => _CustomInputLargeState();
}

class _CustomInputLargeState extends State<CustomInputLarge> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant CustomInputLarge oldWidget) {
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
      height: widget.deviceSize.height * 0.32,
      width: widget.deviceSize.width * 0.9,
      child: TextField(
        controller: _textController,
        maxLines: null,
        minLines: 10,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLength: widget.maxLength,
        onChanged: widget.onChangeMethod,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
          errorText: widget.errorText,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 15
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
