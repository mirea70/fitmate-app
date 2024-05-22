import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:flutter/material.dart';

import 'MateRegisterView1.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('메인 페이지'),
      ),
      body: Center(
        child: CustomButton(
          deviceSize: deviceSize,
          onTapMethod: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MateRegisterView1()));
          },
          title: '메이트 등록',
          isEnabled: true,
        ),
      ),
    );
  }
}
