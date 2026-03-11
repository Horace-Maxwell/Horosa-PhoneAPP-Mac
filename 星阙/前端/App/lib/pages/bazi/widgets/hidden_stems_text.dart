import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/horosa.dart';

class HiddenStemsText extends StatelessWidget {
  const HiddenStemsText({super.key, required this.stems, required this.label});

  final Stems stems;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
      softWrap: false,
      TextSpan(
        children: [
          TextSpan(
            text: stems.label,
            style: TextStyle(
              color: stems.element.color,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: label,
            style: TextStyle(
              color: const Color(0xff222426),
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}