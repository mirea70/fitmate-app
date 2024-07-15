import 'package:fitmate_app/view/mate/MateListSearchView.dart';
import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:fitmate_app/widget/CustomInputWithoutFocus.dart';
import 'package:flutter/material.dart';

class MateSearchView extends StatefulWidget {
  const MateSearchView({super.key});

  @override
  State<MateSearchView> createState() => _MateSearchViewState();
}

class _MateSearchViewState extends State<MateSearchView> {

  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: devicePadding.top + deviceSize.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(deviceSize.width * 0.03, 0, deviceSize.width * 0.03, 0),
            child: Row(
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
                SizedBox(
                  width: deviceSize.width * 0.04,
                ),
                Container(
                  // width: deviceSize.width * 0.9,
                  height: deviceSize.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffE8E8E8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: deviceSize.width * 0.03,
                      ),
                      Icon(Icons.search),
                      SizedBox(
                        width: deviceSize.width * 0.02,
                      ),
                      CustomInputWithoutFocus(
                        deviceSize: deviceSize * 0.75,
                        hintText: '관심사, 지역명 등을 입력해보세요',
                        onSubmitted: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MateListSearchView(keyword: value)));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
