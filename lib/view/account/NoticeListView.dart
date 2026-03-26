import 'package:fitmate_app/model/account/NoticeResponse.dart';
import 'package:fitmate_app/repository/account/AccountRepository.dart';
import 'package:fitmate_app/view/mate/MateDetailView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final noticeListProvider = FutureProvider.autoDispose<List<NoticeResponse>>((ref) async {
  return ref.read(accountRepositoryProvider).getMyNotices();
});

class NoticeListView extends ConsumerWidget {
  const NoticeListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size deviceSize = MediaQuery.of(context).size;
    final noticesAsync = ref.watch(noticeListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '알림',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: noticesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '알림을 불러올 수 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        data: (notices) {
          if (notices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 50, color: Colors.grey),
                  SizedBox(height: deviceSize.height * 0.02),
                  Text(
                    '알림이 없습니다.',
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: notices.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Color(0xffE8E8E8)),
            itemBuilder: (context, index) {
              final notice = notices[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications, color: Colors.orangeAccent, size: 22),
                ),
                title: Text(
                  notice.content,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MateDetailView(mateId: notice.matingId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
