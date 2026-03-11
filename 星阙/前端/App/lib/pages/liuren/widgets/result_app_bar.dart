import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/liu_lines.dart';
import 'package:horosa/models/liu_ren.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/pages/liuyao/result.dart';
import 'package:horosa/pages/qimen/result.dart';
import 'package:horosa/services/qi_men.dart';
import 'package:horosa/services/six_line.dart';
import 'package:horosa/utils/toast.dart';
import 'package:lunar/lunar.dart';

class LiuRenResultAppBar extends StatelessWidget {
  const LiuRenResultAppBar({super.key, required this.input});

  final LiuRenInput input;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            Solar solar = Solar.fromYmdHms(
              input.guaTime.year,
              input.guaTime.month,
              input.guaTime.day,
              input.guaTime.hour,
              input.guaTime.minute,
              0,
            );
            LiuYaoInput i = LiuYaoInput(
              guaType: 2,
              question: input.question,
              country: input.country,
              address: input.address,
              lines: '',
              jieqi: solar.getLunar().getPrevJieQi(true).getName(),
              hseb: Hseb(
                year: solar.getLunar().getYearInGanZhi(),
                month: solar.getLunar().getMonthInGanZhi(),
                day: solar.getLunar().getDayInGanZhi(),
                hour: solar.getLunar().getTimeInGanZhi(),
              ),
              guaTime: LiuYaoGuaTime(
                year: solar.getYear(),
                month: solar.getMonth(),
                day: solar.getDay(),
                hour: solar.getHour(),
                minute: solar.getMinute(),
              ),
              isSave: 2,
            );
            try {
              final res = await SixLineSvc.getSixLinesResult(i);
              if (!context.mounted) return;
              if (res.statusCode == 200 && res.data['code'] == 0) {
                Navigator.of(context).pushReplacementNamed(
                  LiuYaoResultPage.route,
                  arguments: ArchiveItem(
                    extras: {},
                    id: res.data['data']['record_id'] ?? 0,
                    input: i.toJson(),
                    output: res.data['data'],
                    type: 2,
                    saveType: 1,
                  ),
                );
              } else {
                toast(res.data['msg'] ?? '切换失败，请稍后重试');
              }
            } catch (_) {
              if (!context.mounted) return;
              toast('切换失败，请检查网络后重试');
            }
          },
          child: Text(
            '六爻',
            style: TextStyle(
              color: const Color(0xff86878b),
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 56.w),
        Text(
          '六壬',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(width: 56.w),
        GestureDetector(
          onTap: () async {
            QiMenInput i = QiMenInput(
              guaType: 1,
              question: input.question,
              country: input.country,
              address: input.address,
              guaTime: QiMenGuaTime(
                year: input.guaTime.year,
                month: input.guaTime.month,
                day: input.guaTime.day,
                hour: input.guaTime.hour,
                minute: input.guaTime.minute,
              ),
              isSave: 2,
            );
            try {
              final res = await QiMenSvc.getQiMenResult(i);
              if (!context.mounted) return;
              if (res.statusCode == 200 && res.data['code'] == 0) {
                Navigator.of(context).pushReplacementNamed(
                  QiMenResultPage.route,
                  arguments: ArchiveItem(
                    extras: {},
                    id: res.data['data']['record_id'] ?? 0,
                    input: i.toJson(),
                    output: res.data['data'],
                    type: 3,
                    saveType: 1,
                  ),
                );
              } else {
                toast(res.data['msg'] ?? '切换失败，请稍后重试');
              }
            } catch (_) {
              if (!context.mounted) return;
              toast('切换失败，请检查网络后重试');
            }
          },
          child: Text(
            '奇门',
            style: TextStyle(
              color: const Color(0xff86878b),
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }
}
