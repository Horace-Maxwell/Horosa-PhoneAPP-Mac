import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/pages/pages.dart';
import 'package:horosa/providers/auth.dart';
import 'package:horosa/utils/cache_manage.dart';
import 'package:horosa/utils/toast.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final userInfo =  Provider.of<AuthProvider>(context, listen: true).userInfo;
    final isLoggedIn =  Provider.of<AuthProvider>(context, listen: true).isLoggedIn;
    final CacheManager cacheManager = CacheManager();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffbfbfb),
        surfaceTintColor: const Color(0xfffbfbfb),
        centerTitle: true,
        title: Text(
          '我的',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.w),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                context.read<AuthProvider>().isLoggedIn
                    ? Navigator.of(context).pushNamed(UserInfoPage.route)
                    :Navigator.of(context).pushNamed(LoginPage.route);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: const Color(0x13222327),
                      blurRadius: 12.r,
                      offset: Offset(0, 8.w),
                      spreadRadius: -4.r,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: ShapeDecoration(
                        color: const Color(0xfff2f2f2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        image: userInfo?.avatar != null ?  DecorationImage(
                          image: NetworkImage(userInfo?.avatar ?? ''),
                          fit: BoxFit.contain,
                        ) : null,
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userInfo?.name ?? '请登录',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 28.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 5.w),
                            decoration: ShapeDecoration(
                              color: const Color(0xfff2f2f2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                            child: isLoggedIn ? GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(EditUserInfoPage.route, arguments: EditUserInfoForm(
                                  type: EditUserInfoType.self,
                                  payload: userInfo,
                                ));
                              },
                              child: Text(
                                '编辑',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ) :  Text(
                              '登录后才能解锁更多功能哦~',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: 'SourceHanSansCN',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.w),
            Expanded(
              child: GridView.count(
                padding: EdgeInsets.only(bottom: 30.w),
                crossAxisCount: 2,
                mainAxisSpacing: 24.w,
                crossAxisSpacing: 24.w,
                children: <Widget>[
                  GridItem(
                    icon: SvgPicture.asset(
                      'assets/icons/settings.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '偏好设置',
                    onPressed: () {
                      Navigator.of(context).pushNamed(SettingsPage.route);
                    },
                  ),
                  GridItem(
                    icon: SvgPicture.asset(
                      'assets/icons/user-add.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '生辰库',
                    onPressed: () {
                      if(!context.read<AuthProvider>().isLoggedIn) {
                        toast('请先登录~');
                        return;
                      }
                      Navigator.of(context).pushNamed(BirthDataRepo.route);
                    },
                  ),
                  GridItem(
                    icon: SvgPicture.asset(
                      'assets/icons/info.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '关于我们',
                    onPressed: () {
                      Navigator.of(context).pushNamed(AboutUsPage.route);
                    },
                  ),
                  GridItem(
                    icon: SvgPicture.asset(
                      'assets/icons/edit.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '意见反馈',
                    onPressed: () {
                      if(!context.read<AuthProvider>().isLoggedIn) {
                        toast('请先登录~');
                        return;
                      }
                      Navigator.of(context).pushNamed(FeedbackPage.route);
                    },
                  ),
                  GridItem(
                    onPressed: () async {
                      await cacheManager.clearCache();
                      toast('缓存清理中~');
                      Future.delayed(const Duration(seconds: 1), () {
                        toast('缓存已清除~');
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/garbage-bin.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '清除缓存',
                  ),
                  GridItem(
                    icon: SvgPicture.asset(
                      'assets/icons/lock.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '隐私政策',
                    onPressed: () {
                      Navigator.of(context).pushNamed(PrivacyPolicyPage.route);
                    },
                  ),
                  GridItem(
                    icon: SvgPicture.asset(
                      'assets/icons/document.svg',
                      width: 34.w,
                      height: 34.w,
                    ),
                    label: '用户协议',
                    onPressed: () {
                      Navigator.of(context).pushNamed(TermsOfServicePage.route);
                    },
                  ),
                  // 添加其他项目
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final void Function()? onPressed;

  const GridItem({super.key, required this.icon, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x13222327),
            blurRadius: 12.r,
            offset: Offset(0, 8.w),
            spreadRadius: -4.r,
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          onPressed?.call();
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 86.w,
                height: 86.w,
                decoration: ShapeDecoration(
                  color: const Color(0xff222426),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Center(child: icon),
              ),
              SizedBox(height: 30.w),
              Text(label, style: TextStyle(fontSize: 30.sp, color: const Color(0xff222426))),
            ],
          ),
        ),
      ),
    );
  }
}
