import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  const CustomInput({required this.deviceSize, required this.onChangeMethod, required this.hintText, this.errorText, this.maxLength, required this.text, this.obscureText = false});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;
  final String hintText;
  final String? errorText;
  final int? maxLength;
  final String text;
  final bool obscureText;

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
    if (widget.text != _textController.text) {
      _textController.text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.deviceSize.height * 0.08,
      ),
      width: widget.deviceSize.width * 0.9,
      child: TextField(
        contextMenuBuilder: (context, editableTextState) => const SizedBox.shrink(),
        controller: _textController,
        maxLength: widget.maxLength,
        obscureText: widget.obscureText,
        onChanged: widget.onChangeMethod,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintMaxLines: 2,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          errorText: widget.errorText,
          errorMaxLines: 2,
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
