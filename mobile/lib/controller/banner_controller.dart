import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BannerController extends StatefulWidget {
  const BannerController({
    super.key,
    required this.images,               // List<String> đường dẫn ảnh
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.onTap,
  });

  final List<String> images;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final void Function(int index)? onTap;

  @override
  State<BannerController> createState() => _BannerControllerState();
}

class _BannerControllerState extends State<BannerController> {
  late final PageController _pc;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pc = PageController(viewportFraction: 0.9, keepPage: true);
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant BannerController oldWidget) {
    super.didUpdateWidget(oldWidget);
    // nếu danh sách đổi/autoPlay đổi, khởi động lại timer
    if (oldWidget.autoPlay != widget.autoPlay ||
        oldWidget.autoPlayInterval != widget.autoPlayInterval ||
        oldWidget.images.length != widget.images.length) {
      _stopTimer();
      _startTimer();
    }
  }

  void _startTimer() {
    if (!widget.autoPlay || widget.images.isEmpty) return;
    _timer ??= Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || widget.images.isEmpty) return;
      final next = (_index + 1) % widget.images.length;
      if (_pc.hasClients) {
        _pc.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imgs = widget.images;
    if (imgs.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Dừng autoPlay khi user tương tác, tiếp tục sau khi thả
        Listener(
          onPointerDown: (_) => _stopTimer(),
          onPointerUp: (_) => _startTimer(),
          child: SizedBox(
            height: 180.h,
            child: PageView.builder(
              controller: _pc,
              onPageChanged: (i) => setState(() => _index = i),
              itemCount: imgs.length,
              itemBuilder: (_, i) {
                final src = imgs[i];
                final isNetwork = src.startsWith('http');
                final image = isNetwork
                    ? Image.network(src, fit: BoxFit.cover, width: double.infinity)
                    : Image.asset(src, fit: BoxFit.cover, width: double.infinity);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: GestureDetector(
                    onTap: () => widget.onTap?.call(i),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: image,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imgs.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 8.h,
              width: active ? 20.w : 8.w,
              decoration: BoxDecoration(
                color: active ? Colors.redAccent : Colors.black26,
                borderRadius: BorderRadius.circular(8.r),
              ),
            );
          }),
        ),
      ],
    );
  }
}
