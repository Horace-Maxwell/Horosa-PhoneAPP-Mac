import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/constants/constant.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/widgets/single_picker.dart';

/// 五行长生
class FivePhasesGrowth extends StatefulWidget {
  const FivePhasesGrowth({super.key});

  @override
  State<FivePhasesGrowth> createState() => _FivePhasesGrowthState();
}

class _FivePhasesGrowthState extends State<FivePhasesGrowth> {
  FivePhasesGrowthItem _item = fivePhasesGrowthList[0];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return SimpleDialog(
                  contentPadding: EdgeInsets.zero,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 110.w,
                              left: 102.w,
                              right: 102.w,
                              bottom: 50.w),
                          width: 1.sw - 72.w,
                          height: 593.w,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 463.w,
                                height: 32.w,
                                decoration: const BoxDecoration(
                                    color: Color(0xff393b41)),
                                child: Center(
                                  child: Text(
                                    '旺衰长生',
                                    style: TextStyle(
                                      color: const Color(0xfff8cc76),
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 23.w),
                                width: 463.w,
                                height: 48.w,
                                decoration: ShapeDecoration(
                                  color: const Color(0xfff2f2f2),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.w,
                                        color: const Color(0xffcccccc)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '五行',
                                      style: TextStyle(
                                        color: const Color(0xff393b41),
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        SinglePicker(
                                          height: 560.w,
                                          options: fivePhasesGrowthList,
                                          value: _item.value,
                                          mapper: (option) {
                                            return PickerItem(
                                              label: option.label,
                                              value: option.value,
                                            );
                                          },
                                          onChange: (selected) {
                                            setState(() {
                                              _item = selected;
                                            });
                                          },
                                        ).show(context);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            _item.label,
                                            style: TextStyle(
                                              color: const Color(0xff393b41),
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          SvgPicture.asset(
                                            'assets/icons/arrow-down-fill.svg',
                                            width: 20.w,
                                            height: 24.w,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Image.asset(_item.src),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 30.w,
                          right: 30.w,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              width: 72.w,
                              child: Text(
                                '关闭',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          },
        );
      },
      child: Container(
        width: 134.w,
        padding: EdgeInsets.symmetric(vertical: 8.w),
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34.r),
            side: BorderSide(
              width: 1.w,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: const Color(0xff222426),
            ),
          ),
        ),
        child: Center(
          child: Text(
            '五行长生',
            style: TextStyle(
              color: const Color(0xff222426),
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
