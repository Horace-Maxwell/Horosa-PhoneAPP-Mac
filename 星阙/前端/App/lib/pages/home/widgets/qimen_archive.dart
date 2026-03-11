import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/qi_men.dart';

class QimenArchive extends StatelessWidget {
  const QimenArchive({super.key, required this.data});

  final ArchiveItem<QiMenInput, QiMenResult, QiMenExtras> data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              data.output.paiju.substring(0, 4),
              style: TextStyle(
                color: const Color(0xff222426),
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.w),
        Text(
          '占问: ${data.input.question ?? ''}',
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 30.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
