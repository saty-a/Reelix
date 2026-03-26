import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/reel_controller.dart';
import '../../../data/models/dto/reel.dart';
import '../../../data/values/app_images.dart';

class ReelView extends GetView<ReelController> {
  const ReelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        );
      }

      if (controller.reels.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_outline,
                color: Colors.grey[700],
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'No reels yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        );
      }

      return Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.reels.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return _ReelItem(
                reel: controller.reels[index],
                index: index,
                controller: controller,
              );
            },
          ),
          Obx(() => controller.isOffline.value
              ? Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'You are offline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      );
    });
  }
}

class _ReelItem extends StatelessWidget {
  final Reel reel;
  final int index;
  final ReelController controller;

  const _ReelItem({
    required this.reel,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery
        .of(context)
        .padding
        .bottom;

    return GestureDetector(
      onTap: () => controller.togglePlayPause(index),
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _VideoWidget(index: index, controller: controller),
            _PauseOverlay(index: index, controller: controller),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 120,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 320,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: bottomPadding + 100,
              child: _ActionButtons(reel: reel),
            ),
            Positioned(
              left: 16,
              right: 20,
              bottom: bottomPadding + 20,
              child: _BottomInfo(reel: reel, index: index),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPadding,
              child: _VideoProgressBar(index: index, controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Reel reel;

  const _ActionButtons({required this.reel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GlassAction(
          icon: Icons.favorite_rounded,
          iconColor: const Color(0xFFFF4458),
          label: _formatCount(reel.likes),
        ),
        const SizedBox(height: 20),
        _GlassAction(
          icon: Icons.chat_bubble_rounded,
          label: _formatCount(reel.comments),
        ),
        const SizedBox(height: 20),
        _GlassAction(
          icon: Icons.send_rounded,
          label: _formatCount(reel.shares),
        ),
        const SizedBox(height: 20),
        const _GlassAction(icon: Icons.bookmark_border_rounded),
      ],
    );
  }

  static String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    if (count == 0) return '';
    return count.toString();
  }
}

class _GlassAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String? label;

  const _GlassAction({
    required this.icon,
    this.iconColor = Colors.white,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              width: 40,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
          ),
        ),
        if (label != null && label!.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            label!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _BottomInfo extends StatelessWidget {
  final Reel reel;
  final int index;

  const _BottomInfo({required this.reel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  AppImages.getProfilePic(index),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reel.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Icon(Icons.more_vert, color: Colors.white, size: 24),
          ],
        ),
        if (reel.caption.isEmpty) ...[
          const SizedBox(height: 6),
          Text(
            "Behind the scenes with my goofy companion #companion #dogvideo",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

}

class _VideoWidget extends StatelessWidget {
  final int index;
  final ReelController controller;

  const _VideoWidget({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.currentIndex.value;

      final videoController = controller.getController(index);
      if (videoController == null || !videoController.value.isInitialized) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white30,
              strokeWidth: 2,
            ),
          ),
        );
      }

      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: videoController.value.size.width,
          height: videoController.value.size.height,
          child: VideoPlayer(videoController),
        ),
      );
    });
  }
}

class _PauseOverlay extends StatelessWidget {
  final int index;
  final ReelController controller;

  const _PauseOverlay({
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final videoController = controller.getController(index);

    if (videoController == null || !videoController.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      return AnimatedOpacity(
        opacity: controller.isVideoPlaying.value ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Center(
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _VideoProgressBar extends StatelessWidget {
  final int index;
  final ReelController controller;

  const _VideoProgressBar({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.currentIndex.value;

      final videoController = controller.getController(index);
      if (videoController == null || !videoController.value.isInitialized) {
        return const SizedBox(height: 2);
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: SizedBox(
          height: 2.5,
          child: VideoProgressIndicator(
            videoController,
            allowScrubbing: true,
            colors: VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white.withValues(alpha: 0.2),
              backgroundColor: Colors.white.withValues(alpha: 0.08),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      );
    });
  }
}
