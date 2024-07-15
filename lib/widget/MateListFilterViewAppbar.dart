import 'package:fitmate_app/view/mate/MateFilterView.dart';
import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MateListFilterViewAppbar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const MateListFilterViewAppbar({
    required this.deviceSize,
    required this.devicePadding,
  });

  final Size deviceSize;
  final EdgeInsets devicePadding;

  @override
  ConsumerState<MateListFilterViewAppbar> createState() => _MateListFilterViewAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(deviceSize.height * 0.05);
}

class _MateListFilterViewAppbarState extends ConsumerState<MateListFilterViewAppbar> {
@override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.deviceSize.width * 0.05, 0, widget.deviceSize.width * 0.05, 0),
      child: Column(
        children: [
          SizedBox(
            height: widget.devicePadding.top,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomIconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 27,
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: SizedBox(
                ),
              ),
              Text(
                '필터 결과',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              ),
              Expanded(
                child: SizedBox(
                ),
              ),
              CustomIconButton(
                icon: Icon(
                  Icons.filter_alt_outlined,
                  size: 27,
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
