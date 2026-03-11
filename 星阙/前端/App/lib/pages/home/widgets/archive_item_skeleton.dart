import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ArchiveItemSkeleton extends StatelessWidget {
  const ArchiveItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(bottom: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
      decoration: ShapeDecoration(
        color: const Color(0xffffffff),
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
          Shimmer.fromColors(
            baseColor: const Color(0xffeeeeee),
            highlightColor: const Color(0xffcccccc),
            child: Container(
              width: 80.w,
              height: 30.w,
              decoration: ShapeDecoration(
                color: const Color(0xfff8cc76),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.w),
          Shimmer.fromColors(
            baseColor: const Color(0xffeeeeee),
            highlightColor: const Color(0xffcccccc),
            child: Container(
              width: 1.sw,
              height: 30.w,
              color: const Color(0xfff8cc76),
            ),
          ),
          SizedBox(height: 20.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: const Color(0xffeeeeee),
                  highlightColor: const Color(0xffcccccc),
                  child: Container(
                    width: 80.w,
                    height: 30.w,
                    color: const Color(0xfff8cc76),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Shimmer.fromColors(
                baseColor: const Color(0xffeeeeee),
                highlightColor: const Color(0xffcccccc),
                child: Container(
                  width: 80.w,
                  height: 30.w,
                  color: const Color(0xfff8cc76),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
