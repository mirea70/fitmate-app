import 'package:fitmate_app/view_model/BaseViewModel.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.resetViewModel,
    required this.deviceSize,
    required this.devicePadding,
    required this.step,
    required this.totalStep,
    this.onPressed,
  });

  final BaseViewModel? resetViewModel;
  final Size deviceSize;
  final EdgeInsets devicePadding;
  final int step;
  final int totalStep;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: devicePadding.top,
          ),
          Row(
            children: [
              Container(
                color: Colors.orangeAccent,
                height: 6,
                width: deviceSize.width / totalStep * step,
              ),
              Container(
                color: Color(0xffE8E8E8),
                height: 6,
                width: deviceSize.width / totalStep * (totalStep - step),
              ),
            ],
          ),
          SizedBox(
            height: deviceSize.height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.only(left: deviceSize.width * 0.02),
            child: IconButton(
              onPressed: onPressed != null
                  ? onPressed
                  : () {
                if (resetViewModel != null) resetViewModel!.reset();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          SizedBox(
            height: deviceSize.height * 0.05,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(deviceSize.height * 0.1);
}
