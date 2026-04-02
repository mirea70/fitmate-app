import 'package:fitmate_app/view/account/MyProfileView.dart';
import 'package:fitmate_app/view/chat/ChatListView.dart';
import 'package:fitmate_app/view/mate/MateListView.dart';
import 'package:fitmate_app/view/mate/MateRegisterView1.dart';
import 'package:fitmate_app/view_model/account/NoticeViewModel.dart';
import 'package:fitmate_app/view_model/chat/ChatRoomListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  static _MainViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainViewState>();

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int _selectedIndex = 0;

  void selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    ref.read(unreadNoticeCountProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatRoomListProvider);
    final totalUnread = chatState.whenOrNull(
      data: (data) => data.rooms.fold<int>(0, (sum, room) => sum + room.unreadCount),
    ) ?? 0;

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
              icon: totalUnread > 0
                  ? Badge(
                      label: Text(
                        totalUnread > 99 ? '99+' : '$totalUnread',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.chat),
                    )
                  : Icon(Icons.chat),
              label: '채팅'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '마이페이지'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: selectTab,
      ),
    );
  }
}
