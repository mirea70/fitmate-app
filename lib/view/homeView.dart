import 'dart:ui';

import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:fitmate_app/widget/CustomButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            // Container(
            // color: Color(0xffFF9800),
            // color: Colors.orangeAccent,
            // decoration: BoxDecoration(
            //   // gradient: LinearGradient(
            //   //   colors: [
            //   //     Color(0xfff6d365).withOpacity(0.7),
            //   //     Color(0xfffda085)
            //   //   ],
            //   //   begin: Alignment.topRight,
            //   //   end: Alignment.bottomLeft,
            //   // ),
            //   image: DecorationImage(
            //     image: AssetImage(
            //         'assets/images/fitmate_bg.jpg',
            //     ),
            //     fit: BoxFit.fill,
            //   )
            // ),
            // ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.15,
                  ),
                  Center(
                    child: ClipPath(
                      clipper: TrapezoidClipper(),
                      child: Container(
                        alignment: Alignment.center,
                        height: deviceSize.height * 0.08,
                        width: deviceSize.width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.orangeAccent,
                        ),
                        child: Text(
                          'FitMate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.2,
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top*0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '아직도 혼자 운동하세요?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          '이제,',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          '운동 메이트와 함께 해봐요!',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: deviceSize.width * 0.9,
                      //   height: deviceSize.height * 0.07,
                      //   decoration: BoxDecoration(
                      //     color: Colors.yellowAccent,
                      //     borderRadius: BorderRadius.all(Radius.circular(30)),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.start_rounded),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       Text(
                      //         ,
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      CustomButton(
                        deviceSize: deviceSize,
                        onTapMethod: (){},
                        title: '카카오톡으로 5초만에 시작하기',
                        isEnabled: true,
                        color: Colors.yellowAccent,
                        textColor: Colors.black87,
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.02,
                      ),
                      CustomButton(
                        deviceSize: deviceSize,
                        onTapMethod: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginView();
                              },
                            ),
                          );
                        },
                        title: '다른 방법으로 시작하기',
                        isEnabled: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.9); // 좌하단
    path.lineTo(size.width * 0.13, size.height * 0.1); // 우하단
    path.lineTo(size.width * 0.95, size.height * 0.1); // 우상단
    path.lineTo(size.width * 0.87, size.height * 0.9); // 좌상단
    path.close(); // 닫힌 도형 만들기
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
