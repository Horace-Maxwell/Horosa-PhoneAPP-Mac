import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/horosa.dart';

class StemsOrBranchText extends StatelessWidget {
  const StemsOrBranchText({super.key, required this.element});

  final StemsOrBranchElement element;

  @override
  Widget build(BuildContext context) {
    return Text(
      element.label,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: element.element.color,
        fontSize: 48.sp,
        fontFamily: 'SourceHanSansCN',
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    );
  }
}
