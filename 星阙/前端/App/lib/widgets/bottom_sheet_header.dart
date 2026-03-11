import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetHeader extends StatelessWidget {

  const BottomSheetHeader({super.key, this.title, this.onCancel, this.onConfirm});

  /// title
  final Widget? title;

  /// onCancel
  final Function()? onCancel;

  /// onConfirm
  final Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            onCancel?.call();
            Navigator.pop(context);
          },
          child: SizedBox(
            height: 43.w,
            child: Text(
              '取消',
              style: TextStyle(
                color: const Color(0xff393b41),
                fontSize: 30.sp,
                fontFamily: 'SourceHanSansCN',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
        ),
        if(title != null) title!,
        GestureDetector(
          onTap: () {
            onConfirm?.call();
          },
          child: SizedBox(
            height: 43.w,
            child: Text(
              '确定',
              style: TextStyle(
                color: const Color(0xfff1ac62),
                fontSize: 30.sp,
                fontFamily: 'SourceHanSansCN',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
