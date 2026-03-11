import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/models/gender.dart';
import 'package:horosa/pages/home/page.dart';
import 'package:horosa/providers/auth.dart';
import 'package:horosa/services/profile.dart';
import 'package:horosa/utils/local_storage.dart';
import 'package:horosa/widgets/chn_place_picker.dart';
import 'package:horosa/widgets/forms/forms.dart';
import 'package:provider/provider.dart';

import 'edit_user_info.dart';

class UserInfoPage extends StatelessWidget {
  static const String route = '/profile/user-info';

  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = context.read<AuthProvider>().userInfo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffbfbfb),
        surfaceTintColor: const Color(0xfffbfbfb),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow-left.svg',
            width: 17.w,
            height: 32.w,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          '个人信息',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 28.w),
              Container(
                width: 100.w,
                height: 100.w,
                decoration: ShapeDecoration(
                  color: const Color(0xffd7d7d7),
                  shape: const OvalBorder(
                    side: BorderSide.none,
                  ),
                  image: userInfo?.avatar != null
                      ? DecorationImage(
                          image:
                              NetworkImage(userInfo?.avatar ?? ''),
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 48.w),
              Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffcdcdcd),
                    width: 1.w,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '姓       名',
                      style: TextStyle(
                        color: const Color(0xff88898D),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userInfo?.name ?? '',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Transform.scale(
                        //   scaleX: -1,
                        //   child: SvgPicture.asset(
                        //     'assets/icons/arrow-left.svg',
                        //     width: 16.w,
                        //     height: 30.w,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffcdcdcd),
                    width: 1.w,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '性       别',
                      style: TextStyle(
                        color: const Color(0xff88898D),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    userInfo?.sex != 0
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HorosaRadio(
                                  label: Gender.male.label,
                                  value: Gender.male.aliasValue,
                                  checked: Gender.male.aliasValue ==
                                      userInfo?.sex),
                              SizedBox(width: 52.w),
                              HorosaRadio(
                                  label: Gender.female.label,
                                  value: Gender.female.aliasValue,
                                  checked: Gender.female.aliasValue ==
                                      userInfo?.sex),
                            ],
                          )
                        : Text(
                            '未设置',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.w,
                            ),
                          ),
                    SizedBox(height: 30.w),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffcdcdcd),
                    width: 1.w,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '生       日',
                      style: TextStyle(
                        color: const Color(0xff88898D),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          userInfo?.birthday != null && userInfo!.birthday.isNotEmpty ? userInfo.birthday : '未设置',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Transform.scale(
                        //   scaleX: -1,
                        //   child: SvgPicture.asset(
                        //     'assets/icons/arrow-left.svg',
                        //     width: 16.w,
                        //     height: 30.w,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffcdcdcd),
                    width: 1.w,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '出生地址',
                      style: TextStyle(
                        color: const Color(0xff88898D),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          CHNPlaceLoader.instance.getPlaceFromAdcode(CHNPlaceAdcode(
                            province: userInfo!.birthProvinceId,
                            city: userInfo.birthCityId,
                            county: userInfo.birthDistrictId,
                          )).toFullString(),
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Transform.scale(
                        //   scaleX: -1,
                        //   child: SvgPicture.asset(
                        //     'assets/icons/arrow-left.svg',
                        //     width: 16.w,
                        //     height: 30.w,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: const Color(0xffcdcdcd),
                    width: 1.w,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '现居地',
                      style: TextStyle(
                        color: const Color(0xff88898D),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          CHNPlaceLoader.instance.getPlaceFromAdcode(CHNPlaceAdcode(
                            province: userInfo.residenceProvinceId,
                            city: userInfo.residenceCityId,
                            county: userInfo.residenceDistrictId,
                          )).toFullString(),
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // Transform.scale(
                        //   scaleX: -1,
                        //   child: SvgPicture.asset(
                        //     'assets/icons/arrow-left.svg',
                        //     width: 16.w,
                        //     height: 30.w,
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                  ],
                ),
              ),
              SizedBox(height: 48.w),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushNamed(EditUserInfoPage.route, arguments: EditUserInfoForm(
                    type: EditUserInfoType.self,
                    payload: userInfo,
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 36.w),
                  height: 86.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(43.r),
                      side: BorderSide(
                        color: const Color(0xff222426),
                        width: 2.w
                      )
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '编辑信息',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      children: [
                        Container(
                          width: 1.sw - 72.w,
                          padding: EdgeInsets.symmetric(horizontal: 36.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.w),
                              Text(
                                '确认退出登录？',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 36.w),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        LocalStorage localStorage = LocalStorage();
                                        await localStorage.delete(AppKeys.accessToken);
                                        if (!context.mounted) return;
                                        context.read<AuthProvider>().setUserInfo(null);
                                        context.read<AuthProvider>().setToken(null);
                                        Navigator.of(context).pushNamed(HomePage.route);
                                      },
                                      child: Container(
                                          height: 72.w,
                                          decoration: ShapeDecoration(
                                            color: const Color(0xff222426),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(36.r),
                                            ),
                                          ),
                                          child: Center(
                                              child: Text(
                                                  '确定',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: const Color(0xfff8cc76),
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 36.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          height: 72.w,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius: BorderRadius.circular(36.r),
                                              border: Border.all(
                                                  color: const Color(0xff222426),
                                                  width: 1.w,
                                                  style: BorderStyle.solid
                                              )
                                          ),
                                          child: Center(
                                              child: Text(
                                                  '取消',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: const Color(0xff222426),
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
                },
                child: Container(
                  height: 86.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(43.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '退出登录',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xfff8cc76),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (context) {
                    return SimpleDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      children: [
                        Container(
                          width: 1.sw - 72.w,
                          padding: EdgeInsets.symmetric(horizontal: 36.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.w),
                              Text(
                                '这将删除您的所有个人信息，确认注销账号吗？',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 36.w),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        final res = await ProfileSvc.deregister();
                                        if (!context.mounted) return;
                                        if (res.statusCode == 200 &&
                                            res.data['code'] == 0) {
                                          LocalStorage localStorage = LocalStorage();
                                          await localStorage.delete(AppKeys.accessToken);
                                          if (!context.mounted) return;
                                          context.read<AuthProvider>().setUserInfo(null);
                                          context.read<AuthProvider>().setToken(null);
                                          Navigator.of(context).pushNamed(HomePage.route);
                                        }
                                      },
                                      child: Container(
                                          height: 72.w,
                                          decoration: ShapeDecoration(
                                            color: const Color(0xff222426),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(36.r),
                                            ),
                                          ),
                                          child: Center(
                                              child: Text(
                                                  '确定',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: const Color(0xfff8cc76),
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 36.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          height: 72.w,
                                          decoration: BoxDecoration(
                                              color: const Color(0xffffffff),
                                              borderRadius: BorderRadius.circular(36.r),
                                              border: Border.all(
                                                  color: const Color(0xff222426),
                                                  width: 1.w,
                                                  style: BorderStyle.solid
                                              )
                                          ),
                                          child: Center(
                                              child: Text(
                                                  '取消',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: const Color(0xff222426),
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.w600,
                                                  )
                                              )
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 36.w),
                  height: 86.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(43.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '注销账号',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xfff8cc76),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
