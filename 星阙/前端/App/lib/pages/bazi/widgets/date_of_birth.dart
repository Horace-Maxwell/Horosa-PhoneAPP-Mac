import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/calendar.dart';
import 'package:horosa/widgets/widgets.dart';

enum DateOfBirthType {
  time,
  pillars,
}

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({super.key, this.value, this.onChange, this.onSwitchTab});

  final Calendar? value;
  final void Function(Calendar)? onChange;
  final void Function(DateOfBirthType)? onSwitchTab;

  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  DateOfBirthType type = DateOfBirthType.time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CapsuleTab<DateOfBirthType>(
          itemExtent: 52.w,
          options: const [
            {'label': '时间输入', 'value': DateOfBirthType.time},
            {'label': '四柱输入', 'value': DateOfBirthType.pillars},
          ],
          value: type,
          onChange: (value) {
            if (widget.value != null && value != type) {
              widget.onChange?.call(Calendar(
                  type: DateOfBirthType.pillars == value
                      ? CalendarType.pillars
                      : CalendarType.solar,
                  value: widget.value!.value));
            }
            widget.onSwitchTab?.call(value);
            if (DateOfBirthType.time == value) {
              DateTimePicker(
                value: widget.value,
                onChange: widget.onChange,
              ).show(context);
            }
            if (DateOfBirthType.pillars == value) {
              FourPillarsPicker(
                value: widget.value,
                onChange: widget.onChange,
              ).show(context);
            }
            setState(() {
              type = value;
            });
          },
        ),
        SizedBox(height: 30.w),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30.w),
          width: 1.sw,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color(0xffcdcdcd),
                width: 1.w,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '出生时间：',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (DateOfBirthType.time == type) {
                      DateTimePicker(
                        value: widget.value,
                        onChange: widget.onChange,
                      ).show(context);
                    }
                    if (DateOfBirthType.pillars == type) {
                      FourPillarsPicker(
                        value: widget.value,
                        onChange: widget.onChange,
                      ).show(context);
                    }
                  },
                  child: widget.value == null
                      ? Text(
                          '请选择您的出生时间',
                          style: TextStyle(
                            color: const Color(0x66393b41),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text(
                          widget.value.toString(),
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
        ),
      ],
    );
  }
}
