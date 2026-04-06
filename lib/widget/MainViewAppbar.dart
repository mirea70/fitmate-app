import 'package:fitmate_app/view/account/NoticeListView.dart';
import 'package:fitmate_app/view_model/account/NoticeViewModel.dart';
import 'package:fitmate_app/view/mate/MateFilterView.dart';
import 'package:fitmate_app/view/mate/MateSearchView.dart';
import 'package:fitmate_app/view/mate/WishListView.dart';
import 'package:fitmate_app/widget/CustomIconButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainViewAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const MainViewAppbar({super.key});

  // AppBar 기본 높이 + 하단 타이틀 영역
  static const double _bottomAreaHeight = 68;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + _bottomAreaHeight);

  Widget _buildNoticeIcon(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNoticeCountProvider);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NoticeListView()),
        );
        ref.read(unreadNoticeCountProvider.notifier).refresh();
      },
      child: SizedBox(
        width: 27,
        height: 27,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_outlined, size: 27),
            if (unreadCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false, // AppBar는 하단 safe area 불필요
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ⭐ 핵심
          children: [
            // ===== 상단 AppBar 영역 =====
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FITMATE',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        icon: const Icon(Icons.filter_alt_outlined, size: 27),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => const MateFilterView(),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      CustomIconButton(
                        icon: const Icon(Icons.search, size: 27),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MateSearchView(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      CustomIconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          size: 27,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WishListView(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _buildNoticeIcon(context, ref),
                    ],
                  ),
                ],
              ),
            ),

            // ===== 하단 타이틀 영역 =====
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '메이트 모집',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: 102,
                    height: 2.5,
                    child: ColoredBox(color: Colors.black),
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
