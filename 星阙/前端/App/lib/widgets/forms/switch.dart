import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorosaSwitch extends StatefulWidget {
  final bool? value;
  final Color? color;
  final void Function(bool value)? onChange;

  const HorosaSwitch({super.key, this.value, this.onChange, this.color});

  @override
  State<HorosaSwitch> createState() => _HorosaSwitchState();
}

class _HorosaSwitchState extends State<HorosaSwitch> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSwitched = widget.value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSwitched = !_isSwitched;
          widget.onChange?.call(_isSwitched);
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 56.w,
        height: 36.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          color: _isSwitched ? (widget.color ?? const Color(0xff222426)) : const Color(0xffcdcdcd),
        ),
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              top: 4.w,
              left: _isSwitched ? 20.w : 0,
              right: _isSwitched ? 0 : 20.w,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xffffffff),
                    shape: const OvalBorder(),
                    shadows: [
                      BoxShadow(
                        color: const Color(0x6438455e),
                        blurRadius: 2.r,
                        offset: Offset(0, 2.w),
                      )
                    ],
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
