import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/horosa.dart';

class PillarInteraction extends StatelessWidget {
  const PillarInteraction({
    super.key,
    this.axis = Axis.horizontal,
    this.size,
    required this.a,
    required this.b,
  });

  /// 方向
  final Axis? axis;

  final double? size;

  /// 第一个
  final StemsOrBranchElement a;

  /// 第二个
  final StemsOrBranchElement b;

  @override
  Widget build(BuildContext context) {
    FivePhasesRelS rs = FivePhases.getBothOfInteraction(a.element, b.element);

    bool isDisplay() {
      if (rs == FivePhasesRelS.produce ||
          rs == FivePhasesRelS.beProduced ||
          rs == FivePhasesRelS.same) {
        return true;
      }

      return false;
    }

    double rotateNum() {
      if (rs == FivePhasesRelS.produce) {
        return pi;
      }

      return 0;
    }

    return isDisplay()
        ? Transform.rotate(
            angle: axis == Axis.vertical ? pi / 2 : 0,
            child: Transform.rotate(
              angle: rotateNum(),
              child: SizedBox(
                height: 48.w,
                child: Center(
                  child: SvgPicture.asset(
                    rs == FivePhasesRelS.same
                        ? 'assets/svgs/rounded-line.svg'
                        : 'assets/svgs/line-arrow-left.svg',
                    width: size ?? 48.w,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
