import 'package:flutter/material.dart';
import 'package:mobile/config/assets/app_banner.dart';
import 'package:mobile/config/assets/app_icon.dart';
import 'package:mobile/config/assets/app_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/themes/app_color.dart';
import 'package:mobile/controller/banner_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = 'Danh Thành'; // tạm: dữ liệu mock
  String _location = 'Q12, TP.HCM'; // tạm: dữ liệu mock
  bool _loadingLoc =
      false; // nếu chưa gọi _load(), đừng để true kẻo spinner quay mãi
  final _searchCtl = TextEditingController();
  final List<String> banners = [
    AppBanner.banner_1,
    AppBanner.banner_1,
    AppBanner.banner_1,
  ];

  @override
  void initState() {
    super.initState();
    // _load();
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
                _UserHead(_name),
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
              BannerController(
                images: banners,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _UserHead(String Name) {
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
            ConstrainedBox(
              constraints: BoxConstraints(
                // maxHeight: 140.w,
              ), // ✅ chống tràn AppBar
              child: Text(
                Name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "AROneSans",
                  color: Colors.black,
                  fontSize: 14.h,
                  fontWeight: FontWeight.bold,
                ),
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
