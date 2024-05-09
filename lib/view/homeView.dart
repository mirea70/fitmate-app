import 'dart:ui';

import 'package:fitmate_app/view/account/LoginView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              // color: Color(0xffFF9800),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color(0xfff6d365).withOpacity(0.7),
                //     Color(0xfffda085)
                //   ],
                //   begin: Alignment.topRight,
                //   end: Alignment.bottomLeft,
                // ),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/fitmate_bg.jpg',
                  ),
                  fit: BoxFit.fill,
                )
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: deviceSize.height * 0.15,
                  ),
                  Center(
                    child: Text(
                      'FITMATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w800,
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
                            color: Colors.white,
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
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          '운동 메이트와 함께 해봐요!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
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
                      Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(
                            deviceSize.width * 0.1, 0, deviceSize.width * 0.1, 0),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.start_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '카카오톡으로 5초만에 시작하기',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginView();
                              },
                            ),
                          );
                        },
                        child: Text(
                          '다른 방법으로 시작하기',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
