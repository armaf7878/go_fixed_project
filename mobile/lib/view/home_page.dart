import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/config/assets/app_banner.dart';
import 'package:mobile/config/assets/app_icon.dart';
import 'package:mobile/config/assets/app_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/themes/app_color.dart';
import 'package:mobile/controller/banner_controller.dart';
import 'package:mobile/domain/model/service.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kBaseUrl = AppRouter.main_domain;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '...';
  bool _loadingName = true;
  final String _location = 'Q12, TP.HCM'; // tạm: dữ liệu mock
  final bool _loadingLoc =
      false; // nếu chưa gọi _load(), đừng để true kẻo spinner quay mãi
  final _searchCtl = TextEditingController();
  final List<String> banners = [
    AppBanner.banner_1,
    AppBanner.banner_1,
    AppBanner.banner_1,
  ];
  final List<Service> items = <Service>[
    Service(
      id: '1',
      title: 'Cứu hộ lốp',
      iconUrl: null,
      price: 150000,
      isActive: true,
    ),
    Service(
      id: '2',
      title: 'Kéo xe',
      iconUrl: null,
      price: 350000,
      isActive: true,
    ),
    Service(
      id: '3',
      title: 'Ắc quy',
      iconUrl: null,
      price: 250000,
      isActive: true,
    ),
    Service(
      id: '4',
      title: 'Nhiên liệu',
      iconUrl: null,
      price: 200000,
      isActive: true,
    ),
    Service(
      id: '3',
      title: 'Ắc quy',
      iconUrl: null,
      price: 250000,
      isActive: true,
    ),
    Service(
      id: '4',
      title: 'Nhiên liệu',
      iconUrl: null,
      price: 200000,
      isActive: true,
    ),
    Service(
      id: '3',
      title: 'Ắc quy',
      iconUrl: null,
      price: 250000,
      isActive: true,
    ),
    Service(
      id: '4',
      title: 'Nhiên liệu',
      iconUrl: null,
      price: 200000,
      isActive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadName();
    // _load();
  }

  Future<void> _loadName() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('token'); // đã lưu sau login
      if (token == null) {
        setState(() {
          _name = 'Guest';
          _loadingName = false;
        });
        return;
      }

      final res = await http.get(
        Uri.parse('$kBaseUrl/account/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final user = data['user'] ?? data;
        final name = (user['fullname']).toString();
        setState(() {
          _name = name;
          _loadingName = false;
        });
      } else {
        setState(() {
          _name = 'User';
          _loadingName = false;
        });
      }
    } catch (_) {
      setState(() {
        _name = 'User';
        _loadingName = false;
      });
    }
  }
  // Future<void> _load() async {
  //   final name = await UserRepo.fetchDisplayName();
  //   setState(() => _name = name);

  //   try {
  //     final loc = await UserRepo.fetchLocationLabel();
  //     setState(() {
  //       _location = loc;
  //       _loadingLoc = false;
  //     });
  //   } catch (_) {
  //     setState(() {
  //       _location = 'Location off';
  //       _loadingLoc = false;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.h,
        leadingWidth: 80.h,
        backgroundColor: Colors.transparent,
        // centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 12.r),
          child: Image.asset(AppImages.mainLogo, height: 100.h, width: 40.w),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min, // ✅ chỉ rộng theo nội dung
              children: [
                _userHead(_name),
                SizedBox(width: 10.w),
                _userSetting(),

                ///
              ],
            ),
          ),
        ],
      ),

      // leadingWidth: 44,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtl,
                      style: TextStyle(color: Colors.black),
                      cursorColor: AppColor.primaryColor,
                      onChanged: (q) {
                        // TODO: lọc danh sách theo q
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm...',
                        hintStyle: TextStyle(color: Colors.black38),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        suffixIcon: _searchCtl.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  _searchCtl.clear();
                                  setState(() {}); // cập nhật UI
                                  // TODO: reset lọc nếu cần
                                },
                              ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nút ở BÊN PHẢI, bên ngoài TextField
                  SizedBox(
                    // height: 36.h,
                    child: ElevatedButton(
                      onPressed: () {
                        /* thực thi search */
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: AppColor.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(48, 48), // (tuỳ) đảm bảo đủ lớn
                        padding: EdgeInsets.zero, // (tuỳ) để icon căn giữa
                      ),

                      child: SvgPicture.asset(
                        AppIcon.heart,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              BannerController(
                images: banners,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Services",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 14.w,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // hoặc tính theo màn hình
                    // mainAxisSpacing: 10,
                    // crossAxisSpacing: 5,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: math.min(items.length, 6), // 👈 chỉ lấy tối đa 6
                  itemBuilder: (_, i) {
                    final s = items[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          /* điều hướng tới chi tiết */
                        },
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
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            else
                              const Icon(Icons.home_repair_service, size: 40),
                            // const SizedBox(height: 8),
                            Text(
                              s.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // if (s.title != null)
                            // const SizedBox(height: 8),
                            //   Padding(
                            //     padding: const EdgeInsets.all(16.0),
                            //     child: Text(
                            //       '${s.title}',
                            //       style: const TextStyle(color: Colors.black, fontSize: 10),
                            //     ),
                            //   ),
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
            Text(
              "Hello, ",
              style: TextStyle(
                fontFamily: "AROneSans",
                color: AppColor.primaryColor,
                fontSize: 14.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_loadingName)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Text(
                _name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "AROneSans",
                  color: Colors.black,
                  fontSize: 14.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        // location
        Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 16.h, color: AppColor.primaryColor),
            SizedBox(width: 4.w),
            _loadingLoc
                ? SizedBox(
                    width: 12.w,
                    height: 12.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 160.w),
                    child: Text(
                      _location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.h,
                        fontFamily: "AROneSans",
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
          border: Border.all(color: AppColor.primaryColor, width: 2.5), // viền
        ),
        child: SvgPicture.asset(
          AppIcon.user,
          // width: 20.w,
          // height: 20.w,
          // nếu cần đồng bộ màu:
          // colorFilter: ColorFilter.mode(AppColor.primaryColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
