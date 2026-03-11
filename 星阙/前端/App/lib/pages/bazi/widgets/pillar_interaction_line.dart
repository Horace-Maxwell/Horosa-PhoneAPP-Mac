import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PillarDirection {
  up,
  down,
  left,
  right,
}


class PillarInteractionLine extends CustomPainter {
  final PillarDirection? direction;

  const PillarInteractionLine({this.direction = PillarDirection.down});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xffcdcdcd)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;
    Path path = Path();
    if (direction == null || direction == PillarDirection.down) {
      path.moveTo(0, size.height);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width, size.height);
    }
    if (direction == PillarDirection.up) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
