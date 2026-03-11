import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorosaRadio<T> extends StatelessWidget {

  final String? label;
  final T value;
  final bool? checked;
  final Function(T value)? onChange;

  const HorosaRadio({
    super.key,
    required this.value,
    this.onChange,
    this.label,
    this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange?.call(value);
      },
      child: Container(
        color: const Color(0xffffffff).withOpacity(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: ShapeDecoration(
                shape: OvalBorder(
                  side: BorderSide(width: 2.w, color: const Color(0xff222426)),
                ),
              ),
              child: Center(
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: checked ?? false
                      ? ShapeDecoration(
                          color: const Color(0xff222426),
                          shape: OvalBorder(
                            side: BorderSide(
                                width: 2.w, color: const Color(0xff222426)),
                          ),
                        )
                      : null,
                ),
              ),
            ),
            Visibility(
              visible: (label ?? '').isNotEmpty,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                child: Text(
                  label ?? '',
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
