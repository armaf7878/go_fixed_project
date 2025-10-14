import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile/config/assets/app_icon.dart';
import 'package:mobile/config/assets/app_image.dart';
import 'package:mobile/config/themes/app_color.dart';

import 'package:mobile/controller/user_controller.dart';
import 'package:mobile/controller/banner_controller.dart';
import 'package:mobile/model/service.dart';

// UI widgets
import 'package:mobile/widgets/banner/banner_carousel.dart';
import 'package:mobile/widgets/banner/dots_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- User ---
  UserController? _userCtrl;
  String _name = '...';
  bool _loadingName = true;

  // --- Banner ---
  BannerController? _bannerCtrl;
  int _bannerIndex = 0;

  // mock location + services
  final String _location = 'Q12, TP.HCM';
  final bool _loadingLoc = false;

  final _searchCtl = TextEditingController();
  final List<Service> items = <Service>[
    Service(id: '1', title: 'Cứu hộ lốp', iconUrl: null, price: 150000, isActive: true),
    Service(id: '2', title: 'Kéo xe',     iconUrl: null, price: 350000, isActive: true),
    Service(id: '3', title: 'Ắc quy',     iconUrl: null, price: 250000, isActive: true),
    Service(id: '4', title: 'Nhiên liệu', iconUrl: null, price: 200000, isActive: true),
    Service(id: '5', title: 'Ắc quy',     iconUrl: null, price: 250000, isActive: true),
    Service(id: '6', title: 'Nhiên liệu', iconUrl: null, price: 200000, isActive: true),
    Service(id: '7', title: 'Ắc quy',     iconUrl: null, price: 250000, isActive: true),
    Service(id: '8', title: 'Nhiên liệu', iconUrl: null, price: 200000, isActive: true),
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  Future<void> _initControllers() async {
    // User
    _userCtrl = await UserController.create();
    if (!mounted) return;
    try {
      final n = await _userCtrl!.fetchDisplayName();
      if (!mounted) return;
      setState(() {
        _name = n;
        _loadingName = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _name = 'Chưa đăng nhập';
        _loadingName = false;
      });
    }

    // Banner
    _bannerCtrl = await BannerController.create();
    _bannerCtrl!.addListener(_onBannerChanged);
    await _bannerCtrl!.load(); // gọi API /banners
    if (!mounted) return;
    setState(() {}); // refresh UI lần đầu
  }

  void _onBannerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _bannerCtrl?.removeListener(_onBannerChanged);
    _bannerCtrl?.dispose();
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingBanners = _bannerCtrl?.loading ?? true;
    final bannerError    = _bannerCtrl?.error;
    final bannerItems    = _bannerCtrl?.items ?? const [];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        leadingWidth: 80.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.r),
          child: Image.asset(AppImages.mainLogo, height: 100.h, width: 40.w),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _userHead(_name),
                SizedBox(width: 10.w),
                _userSetting(),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              // Search + nút bên phải
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtl,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: AppColor.primaryColor,
                      onChanged: (q) { /* TODO filter */ },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        hintStyle: const TextStyle(color: Colors.black38),
                        prefixIcon: const Icon(Icons.search, color: Colors.black),
                        suffixIcon: _searchCtl.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.clear, color: Colors.black),
                                onPressed: () { _searchCtl.clear(); setState(() {}); },
                              ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () { /* mở filter nâng cao */ },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffF3F8FB),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: AppColor.primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(48, 48),
                        padding: EdgeInsets.zero,
                      ),
                      child: SvgPicture.asset(AppIcon.heart, color: Colors.black),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Banner + indicator (lấy từ controller)
              if (loadingBanners && bannerItems.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (bannerError != null && bannerItems.isEmpty)
                Text('Lỗi banner: $bannerError')
              else ...[
                BannerCarousel(
                  images: bannerItems.map((e) => e.imageUrl).toList(),
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  onIndexChanged: (i) => setState(() => _bannerIndex = i),
                  onTap: (i) {
                    // TODO: dùng bannerItems[i].linkUrl để mở
                  },
                ),
                SizedBox(height: 10.h),
                DotsIndicator(count: bannerItems.length, index: _bannerIndex),
              ],

              SizedBox(height: 20.h),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Services',
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: math.min(items.length, 6),
                  itemBuilder: (_, i) {
                    final s = items[i];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () { /* TODO điều hướng */ },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (s.iconUrl != null && s.iconUrl!.isNotEmpty)
                              SizedBox(
                                height: 100,
                                child: Image.network(
                                  s.iconUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 16, height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              const Icon(Icons.home_repair_service, size: 40),
                            SizedBox(height: 6.h),
                            Text(
                              s.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userHead(String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text('Hello, ',
              style: TextStyle(
                fontFamily: 'AROneSans',
                color: AppColor.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_loadingName)
              const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))
            else
              Text(name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'AROneSans',
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(Icons.location_on, size: 16.h, color: AppColor.primaryColor),
            SizedBox(width: 4.w),
            _loadingLoc
                ? SizedBox(width: 12.w, height: 12.w, child: const CircularProgressIndicator(strokeWidth: 2))
                : ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 160.w),
                    child: Text(
                      _location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: 'AROneSans',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _userSetting() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColor.primaryColor, width: 2.5),
        ),
        child: SvgPicture.asset(AppIcon.user),
      ),
    );
  }
}
