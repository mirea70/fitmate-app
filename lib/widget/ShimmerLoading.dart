import 'package:flutter/material.dart';

/// 앱 전반에서 사용하는 Shimmer 로딩 효과 위젯들

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  const ShimmerBox.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = BoxShape.circle;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.borderRadius)
                : null,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(-0.4 + 2.0 * _controller.value, 0),
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 메이트 목록 아이템 스켈레톤
class MateListItemSkeleton extends StatelessWidget {
  final Size deviceSize;
  const MateListItemSkeleton({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(width: deviceSize.width * 0.03),
            ShimmerBox(
              width: deviceSize.width * 0.28,
              height: 90,
              borderRadius: 10,
            ),
            SizedBox(width: deviceSize.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerBox(width: 50, height: 22, borderRadius: 10),
                  const SizedBox(height: 6),
                  ShimmerBox(width: deviceSize.width * 0.4, height: 16),
                  const SizedBox(height: 6),
                  ShimmerBox(width: deviceSize.width * 0.35, height: 14),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ShimmerBox.circle(size: 24),
                      const SizedBox(width: 6),
                      ShimmerBox(width: deviceSize.width * 0.25, height: 14),
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

/// 메이트 목록 스켈레톤 (여러 아이템)
class MateListSkeleton extends StatelessWidget {
  final Size deviceSize;
  final int itemCount;
  const MateListSkeleton({super.key, required this.deviceSize, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(deviceSize.width * 0.05, 0, deviceSize.width * 0.05, 0),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) => MateListItemSkeleton(deviceSize: deviceSize),
        separatorBuilder: (context, index) => SizedBox(height: deviceSize.height * 0.02),
      ),
    );
  }
}

/// 채팅방 목록 아이템 스켈레톤
class ChatRoomItemSkeleton extends StatelessWidget {
  const ChatRoomItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          ShimmerBox.circle(size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120, height: 16),
                const SizedBox(height: 8),
                ShimmerBox(width: 200, height: 14),
              ],
            ),
          ),
          ShimmerBox(width: 40, height: 12),
        ],
      ),
    );
  }
}

/// 채팅방 목록 스켈레톤
class ChatListSkeleton extends StatelessWidget {
  final int itemCount;
  const ChatListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ChatRoomItemSkeleton(),
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}

/// 상세 화면 스켈레톤
class DetailViewSkeleton extends StatelessWidget {
  final Size deviceSize;
  const DetailViewSkeleton({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: double.infinity, height: deviceSize.height * 0.38, borderRadius: 0),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: deviceSize.width * 0.6, height: 22),
                const SizedBox(height: 12),
                ShimmerBox(width: deviceSize.width * 0.4, height: 16),
                const SizedBox(height: 20),
                ShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                ShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                ShimmerBox(width: deviceSize.width * 0.7, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 프로필 화면 스켈레톤
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          ShimmerBox.circle(size: 90),
          const SizedBox(height: 16),
          ShimmerBox(width: 100, height: 20),
          const SizedBox(height: 8),
          ShimmerBox(width: 160, height: 14),
        ],
      ),
    );
  }
}

/// 알림 목록 아이템 스켈레톤
class NoticeItemSkeleton extends StatelessWidget {
  const NoticeItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          ShimmerBox.circle(size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 60, height: 12),
                const SizedBox(height: 6),
                ShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                ShimmerBox(width: 50, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NoticeListSkeleton extends StatelessWidget {
  final int itemCount;
  const NoticeListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const NoticeItemSkeleton(),
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
    );
  }
}
