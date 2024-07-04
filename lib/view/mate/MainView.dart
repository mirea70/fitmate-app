import 'package:fitmate_app/view/account/MyProfileView.dart';
import 'package:fitmate_app/view/chat/ChatListView.dart';
import 'package:fitmate_app/view/mate/MateListView.dart';
import 'package:fitmate_app/view/mate/MateRegisterView1.dart';
import 'package:flutter/material.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    final EdgeInsets devicePadding = MediaQuery.of(context).padding;

    final List<Widget> _widgetOptions = [
      MateListView(),
      MateRegisterView1(),
      ChatListView(),
      MyProfileView(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_rounded),
              label: '추가'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: '채팅'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '마이페이지'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
