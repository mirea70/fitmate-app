import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:flutter/material.dart';

class MainViewAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainViewAppbar({
    required this.deviceSize,
    required this.devicePadding,
  });

  final Size deviceSize;
  final EdgeInsets devicePadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
      child: Column(
        children: [
          SizedBox(
            height: devicePadding.top,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FITMATE',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    CustomIconButton(
                      icon: Icon(
                        Icons.filter_alt_outlined,
                        size: 27,
                      ),
                      onPressed: (){},
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.03,
                    ),
                    CustomIconButton(
                      icon: Icon(
                        Icons.search,
                        size: 27,
                      ),
                      onPressed: (){},
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.03,
                    ),
                    CustomIconButton(
                      icon: Icon(
                        Icons.heart_broken_outlined,
                        size: 27,
                      ),
                      onPressed: (){},
                    ),
                    SizedBox(
                      width: deviceSize.width * 0.03,
                    ),
                    CustomIconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        size: 27,
                      ),
                      onPressed: (){},
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceSize.height * 0.03,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '메이트 모집',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                      height: deviceSize.height * 0.008
                  ),
                  Container(
                    height: 2.5,
                    width: 102,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(deviceSize.height * 0.120);
}
