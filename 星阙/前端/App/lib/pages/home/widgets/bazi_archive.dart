import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/horosa.dart';
import 'package:lunar/lunar.dart';

class BaziArchive extends StatelessWidget {
  const BaziArchive({super.key, required this.data});

  final ArchiveItem<BaZiInput, BaZiResult, BaZiExtras> data;

  @override
  Widget build(BuildContext context) {
    Lunar lunar = data.input.birthday.getLunar();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '测试名字: ${data.input.username}',
                style: TextStyle(
                  color: const Color(0xff222426),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              SizedBox(height: 20.w),
              Text(
                '阳历: ${data.input.birthday.toYmdInChinese()}',
                style: TextStyle(
                  color: const Color(0xff222426),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 30.w,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: lunar.getYearGan(),
                      style: TextStyle(
                        color: Stems.getStemsByLabel(lunar.getYearGan()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: lunar.getYearZhi(),
                      style: TextStyle(
                        color: Branches.getBranchByLabel(lunar.getYearZhi()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '年',
              style: TextStyle(
                color: const Color(0xff88898d),
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 30.w,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: lunar.getMonthGan(),
                      style: TextStyle(
                        color: Stems.getStemsByLabel(lunar.getMonthGan()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: lunar.getMonthZhi(),
                      style: TextStyle(
                        color: Branches.getBranchByLabel(lunar.getMonthZhi()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '月',
              style: TextStyle(
                color: const Color(0xff88898d),
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 30.w,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: lunar.getDayGan(),
                      style: TextStyle(
                        color: Stems.getStemsByLabel(lunar.getDayGan()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: lunar.getDayZhi(),
                      style: TextStyle(
                        color: Branches.getBranchByLabel(lunar.getDayZhi()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '日',
              style: TextStyle(
                color: const Color(0xff88898d),
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              width: 30.w,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: lunar.getTimeGan(),
                      style: TextStyle(
                        color: Stems.getStemsByLabel(lunar.getTimeGan()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: lunar.getTimeZhi(),
                      style: TextStyle(
                        color: Branches.getBranchByLabel(lunar.getTimeZhi()).element.color,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              '时',
              style: TextStyle(
                color: const Color(0xff88898d),
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }
}
