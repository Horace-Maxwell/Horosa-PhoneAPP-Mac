import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/constants/liu_ren.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/providers/config.dart';
import 'package:provider/provider.dart';
import 'package:horosa/widgets/forms/forms.dart';

class SettingsPage extends StatefulWidget {
  static String route = '/profile/settings';

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<QiMenType> qimen = QiMenType.values;
  List<LayoutType> liuren = LayoutType.values;

  @override
  Widget build(BuildContext context) {
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
          '设置',
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
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 30.w),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '全局设置',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      children: [
                        Text(
                          '真太阳时默认设置',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        HorosaSwitch(
                          value: context.read<ConfigProvider>().useAST,
                          onChange: (value) {
                            context.read<ConfigProvider>().setAST(value);
                            context.read<ConfigProvider>().saveConfig();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 30.w),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '八字',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      children: [
                        Text(
                          '干支关系连线',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        HorosaSwitch(
                          value: Provider.of<ConfigProvider>(context, listen: true).showBaZiSABLine,
                          onChange: (value) {
                            context.read<ConfigProvider>().setBaZiSABLine(value);
                            context.read<ConfigProvider>().saveConfig();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 30.w),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '奇门遁甲',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      children: [
                        Text(
                          '定局默认设置',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Row(
                          children: [
                            HorosaRadio(
                              label: qimen.first.label,
                              value: qimen.first.value,
                              checked: qimen.first.value == Provider.of<ConfigProvider>(context, listen: true).tuning.value,
                              onChange: (value) {
                                if(value == context.read<ConfigProvider>().tuning.value) return;
                                context.read<ConfigProvider>().setTuning(QiMenType.values.firstWhere((e) => e.value == value));
                                context.read<ConfigProvider>().saveConfig();
                              },
                            ),
                            SizedBox(width: 78.w),
                            HorosaRadio(
                              label: qimen.last.label,
                              value: qimen.last.value,
                              checked: qimen.last.value == Provider.of<ConfigProvider>(context, listen: true).tuning.value,
                              onChange: (value) {
                                if(value == context.read<ConfigProvider>().tuning.value) return;
                                context.read<ConfigProvider>().setTuning(QiMenType.values.firstWhere((e) => e.value == value));
                                context.read<ConfigProvider>().saveConfig();
                              },
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 30.w),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '六壬',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    Row(
                      children: [
                        Text(
                          '布局默认设置',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        HorosaRadio(
                          label: liuren.first.label,
                          value: liuren.first.value,
                          checked: liuren.first.value == Provider.of<ConfigProvider>(context, listen: true).layout.value,
                          onChange: (value) {
                            if(value == context.read<ConfigProvider>().layout.value) return;
                            context.read<ConfigProvider>().setLayout(LayoutType.values.firstWhere((e) => e.value == value));
                            context.read<ConfigProvider>().saveConfig();
                          },
                        ),
                        SizedBox(width: 24.w),
                        HorosaRadio(
                          label: liuren.last.label,
                          value: liuren.last.value,
                          checked: liuren.last.value == Provider.of<ConfigProvider>(context, listen: true).layout.value,
                          onChange: (value) {
                            if(value == context.read<ConfigProvider>().layout.value) return;
                            context.read<ConfigProvider>().setLayout(LayoutType.values.firstWhere((e) => e.value == value));
                            context.read<ConfigProvider>().saveConfig();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
