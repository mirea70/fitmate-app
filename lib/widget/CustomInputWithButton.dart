import 'package:flutter/material.dart';

class CustomInputWithButton extends StatefulWidget {
  const CustomInputWithButton({required this.deviceSize, required this.onChangeMethod,
    required this.hintText, this.errorText, required this.onPressMethod, required this.buttonTitle,
    this.isEnableButton = false, this.maxLength, this.isEnableInput = true, required this.text});
  final Size deviceSize;
  final ValueChanged<String> onChangeMethod;
  final VoidCallback onPressMethod;
  final String hintText;
  final String? errorText;
  final String buttonTitle;
  final bool isEnableButton;
  final int? maxLength;
  final bool isEnableInput;
  final String text;

  @override
  State<CustomInputWithButton> createState() => _CustomInputWithButtonState();
}

class _CustomInputWithButtonState extends State<CustomInputWithButton> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant CustomInputWithButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != _textController.text) {
      _textController.text = widget.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: (widget.deviceSize.height * 0.08).clamp(52.0, 64.0),
      ),
      width: widget.deviceSize.width * 0.9,
      child: TextField(
        controller: _textController,
        enabled: widget.isEnableInput,
        maxLength: widget.maxLength,
        onChanged: widget.onChangeMethod,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(0xffE8E8E8),
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
          errorText: widget.errorText,
          errorMaxLines: 2,
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
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              height: 30,
              child: ElevatedButton(
                onPressed: widget.isEnableButton ? widget.onPressMethod : null,
                style: ElevatedButton.styleFrom(
                  elevation: 3.0,
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 30),
                ),
                child: Text(
                  widget.buttonTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(maxHeight: 34),
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
