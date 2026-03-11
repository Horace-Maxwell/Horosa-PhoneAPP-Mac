import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/city.dart';

class NonChnPlaceList extends StatelessWidget {
  const NonChnPlaceList({super.key, required this.places, this.city, this.onSelected});

  final List<City> places;

  final City? city;

  final Function(City)? onSelected;

  @override
  Widget build(BuildContext context) {
    return places.isNotEmpty
        ? ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onSelected?.call(places[index]);
                },
                child: Container(
                  color: city?.id == places[index].id ? const Color(0xfff6f5f4) : Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(left: 36.w, top: 20.w, right: 36.w),
                    padding: EdgeInsets.only(bottom: 20.w),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 2.w, color: const Color(0xfff1f2ed)))),
                    child: Row(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: const ShapeDecoration(
                            color: Color(0xfff2f2f2),
                            shape: OvalBorder(),
                          ),
                          child: Center(
                            child: Transform.rotate(
                              angle: pi / 4,
                              child: SvgPicture.asset(
                                'assets/icons/navigator.svg',
                                width: 20.w,
                                height: 25.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${places[index].name} (${places[index].stateCode})',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.33,
                                ),
                              ),
                              Text(
                                'lng: ${places[index].longitude}  lat: ${places[index].latitude}',
                                style: TextStyle(
                                  color: const Color(0x66393b41),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Center(
            child: Column(
              children: [
                SizedBox(height: 80.w),
                Image.asset(
                  'assets/images/place-empty.png',
                  width: 300.w,
                  height: 320.w,
                ),
                SizedBox(height: 60.w),
                Text(
                  '哎呀！\n没有地区数据~',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
  }
}
