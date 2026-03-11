import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/liu_lines.dart';
import 'package:horosa/widgets/widgets.dart';
import 'specified_lines.dart';
import 'simulate_lines.dart';
import 'time_lines.dart';

// 起卦方式
enum StartTypes {
  // 指定起卦
  specified('指定起卦', 1, type: 1),
  // 模拟摇卦
  simulate('模拟摇卦', 3, type: 1),
  // 时间起卦
  time('时间起卦', 2, type: 2),;

  final int value;
  final String label;
  final int type;
  const StartTypes(this.label, this.value, {this.type = 1});
}

class LinesAndStartType {
  final List<LineTypes?> lines;
  final StartTypes startType;

  const LinesAndStartType({required this.lines, required this.startType});
}

class LinesStartRunning extends StatefulWidget {
  const LinesStartRunning({super.key, required this.changed, this.onChange});

  final ValueNotifier<bool> changed;
  final Function(LinesAndStartType)? onChange;

  @override
  State<LinesStartRunning> createState() => _LinesStartRunningState();
}

class _LinesStartRunningState extends State<LinesStartRunning> {
  StartTypes _startType = StartTypes.specified;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.changed,
      builder: (context, value, child) {
        return Column(
          key: Key('LinesStartRunning$value'),
          children: [
            CapsuleTab<StartTypes>(
              itemExtent: 52.w,
              options: const [
                {'label': '指定起卦', 'value': StartTypes.specified},
                {'label': '模拟摇卦', 'value': StartTypes.simulate},
                {'label': '时间起卦', 'value': StartTypes.time},
              ],
              value: _startType,
              onChange: (value) {
                setState(() {
                  _startType = value;
                });
              },
            ),
            SizedBox(height: 30.w),
            Visibility(
              visible: StartTypes.specified == _startType,
              child: SpecifiedLines(
                onChange: (value) {
                  widget.onChange?.call(LinesAndStartType(
                    lines: value,
                    startType: _startType,
                  ));
                },
              ),
            ),
            Visibility(
              visible: StartTypes.simulate == _startType,
              child: SimulateLines(
                onChange: (value) {
                  widget.onChange?.call(LinesAndStartType(
                    lines: value,
                    startType: _startType,
                  ));
                },
              ),
            ),
            Visibility(
              visible: StartTypes.time == _startType,
              child: TimeLines(
                  onInit: () {
                    widget.onChange?.call(LinesAndStartType(
                      lines: [],
                      startType: _startType,
                    ));
                  }
              ),
            )
          ],
        );
      },
    );
  }
}
