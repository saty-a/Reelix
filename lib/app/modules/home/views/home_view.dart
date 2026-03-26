import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        controller.onBackPressed();
      },
      child: Obx(() {
        final isReelTab = controller.currentIndex.value == 1;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: isReelTab,
            backgroundColor: Colors.black,
            appBar: _buildAppBar(),
            body: IndexedStack(
              index: controller.currentIndex.value,
              children: controller.pages,
            ),
            bottomNavigationBar: _BottomNavBar(
              currentIndex: controller.currentIndex.value,
              isReelTab: isReelTab,
              onTap: controller.changeTab,
              onReelDoubleTap: controller.onReelTabDoubleTap,
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: const Row(
        children: [
          Icon(Icons.play_circle_fill, color: Colors.orangeAccent, size: 28),
          SizedBox(width: 8),
          Text(
            "Reelix",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      actions: [
        _iconButton(Icons.cast_outlined),
        const SizedBox(width: 6),
        _iconButton(Icons.notifications_none_rounded),
        const SizedBox(width: 6),
        _iconButton(Icons.search_rounded),
        const SizedBox(width: 12),
      ],
    );
  }

  static Widget _iconButton(IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isReelTab;
  final ValueChanged<int> onTap;
  final VoidCallback onReelDoubleTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.isReelTab,
    required this.onTap,
    required this.onReelDoubleTap,
  });

  static const _items = <_NavItem>[
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.play_circle_outline,
      activeIcon: Icons.play_circle_rounded,
      label: 'Reels',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: isReelTab
                ? Colors.black.withValues(alpha: 0.55)
                : Colors.grey[900]!.withValues(alpha: 0.85),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final isActive = i == currentIndex;
              final item = _items[i];

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                onDoubleTap: i == 1 ? onReelDoubleTap : null,
                child: SizedBox(
                  width: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive ? Colors.white : Colors.grey[600],
                        size: 25,
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isActive ? 5 : 0,
                        height: isActive ? 5 : 0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_outline,
                      color: Colors.white24, size: 48),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[800],
                      child: const Icon(Icons.person,
                          color: Colors.white38, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Video title ${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Channel Name  ·  ${(index + 1) * 12}K views  ·  ${index + 1}d ago',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.grey[600], size: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
