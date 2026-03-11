import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/liu_lines.dart';

class LiuyaoArchive extends StatelessWidget {
  const LiuyaoArchive({super.key, required this.data});

  final ArchiveItem<LiuYaoInput, LiuYaoResult, LiuYaoExtras> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.input.guaTime.toString(),
              style: TextStyle(
                color: const Color(0xff222426),
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
            SizedBox(height: 20.w),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  color: const Color(0xff222426),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
                children: [
                  TextSpan(text: data.output.gua.name),
                  TextSpan(text: data.output.changeGua?.name != null ? '  ${data.output.changeGua!.name}' : '')
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '占问: ${data.input.question ?? ''}',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xff222426),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 32.w),
            Text(
              '模拟',
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
