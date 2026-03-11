import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/calendar.dart';
import 'package:horosa/utils/date_time_str_parser.dart';
import 'package:lunar/lunar.dart';
import 'package:horosa/constants/calendar.dart';
import 'package:horosa/widgets/bottom_sheet_header.dart';
import 'package:horosa/widgets/forms/picker.dart';
import 'package:horosa/widgets/capsule_tab.dart';
import 'package:horosa/utils/utils.dart';
import 'sheet_search_bar.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key, this.value, this.onChange});

  final Calendar? value;
  final void Function(Calendar)? onChange;

  void show(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(72.r),
          topRight: Radius.circular(72.r),
        ),
        child: BottomSheet(
          enableDrag: false,
          showDragHandle: false,
          backgroundColor: const Color(0xffffffff),
          onClosing: () {},
          constraints: BoxConstraints(
            maxHeight: 828.w,
            minHeight: 828.w,
          ),
          builder: (context) => Padding(
            padding:
                EdgeInsets.only(left: 36.w, top: 56.w, right: 36.w, bottom: 0),
            child: this,
          ),
        ),
      ),
    );
  }

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  CalendarType _type = CalendarType.solar;
  final List<Map<String, dynamic>> _centuries =
      centuries.map((i) => {'label': '$i', 'value': i}).toList();
  final List<Map<String, dynamic>> _years = generateYears()
      .map((i) => {'label': '$i年', 'value': i.padLeft(2, '0')})
      .toList();
  List<Map<String, dynamic>> _months = [];
  List<Map<String, dynamic>> _days = [];
  final List<Map<String, dynamic>> _hours =
      generateHours().map((i) => {'label': '$i时', 'value': i}).toList();
  final List<Map<String, dynamic>> _minutes =
      generateMinutes().map((i) => {'label': '$i分', 'value': i}).toList();
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;
  int _day = DateTime.now().day;
  int _hour = DateTime.now().hour;
  int _minute = DateTime.now().minute;
  late FixedExtentScrollController _centuryController,
      _yearController,
      _monthController,
      _dayController,
      _hourController,
      _minuteController;

  String getLunarMonthNamed(int month) {
    String monthName = '';
    if (month < 0) {
      monthName = '闰${LunarUtil.MONTH[month.abs()]}';
    } else {
      monthName = LunarUtil.MONTH[month];
    }

    return monthName;
  }

  void _calculateDays() {
    if (_type == CalendarType.solar) {
      _days = generateSolarDays(_year, _month)
          .map((i) => {'label': '$i日', 'value': i})
          .toList();
    } else {
      _days = generateLunarDays(_year, _month)
          .map((i) => {'label': LunarUtil.DAY[i], 'value': i})
          .toList();
    }
    _day = min(_day, 31);
    int index = findOptionIndexByValue(_days, _day);
    if (index == -1) index = 0;
    _dayController.animateToItem(index,
        duration: const Duration(milliseconds: 1), curve: Curves.easeIn);
  }

  void _calculateLunarMonths(int year) {
    if (CalendarType.solar == _type) {
      _calculateDays();
      return;
    }
    if (CalendarType.lunar == _type) {
      _months = generateLunarMonths(year)
          .map((i) => {'label': getLunarMonthNamed(i), 'value': i})
          .toList();
      _month = _months[findOptionIndexByValue(_months, _month.abs())]['value'];
      int index = findOptionIndexByValue(_months, _month);
      _monthController.animateToItem(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      _calculateDays();
    }
  }

  void _solarToLunar() {
    if (CalendarType.lunar == _type) return;
    Solar solar = Solar.fromYmdHms(_year, _month, _day, _hour, _minute, 0);
    Lunar lunar = solar.getLunar();
    _year = lunar.getYear().clamp(1500, 2099);
    _month = lunar.getMonth();
    _day = lunar.getDay();
    _hour = lunar.getHour();
    _minute = lunar.getMinute();
    _months = generateLunarMonths(_year)
        .map((i) => {'label': getLunarMonthNamed(i), 'value': i})
        .toList();
    _days = generateLunarDays(_year, _month)
        .map((i) => {'label': LunarUtil.DAY[i], 'value': i})
        .toList();
  }

  void _lunarToSolar() {
    if (CalendarType.solar == _type) return;
    Lunar lunar = Lunar.fromYmdHms(_year, _month, _day, _hour, _minute, 0);
    Solar solar = lunar.getSolar();
    _year = solar.getYear().clamp(1500, 2099);
    _month = solar.getMonth();
    _day = solar.getDay();
    _hour = solar.getHour();
    _minute = solar.getMinute();
    _months = generateSolarMonths(_year)
        .map((i) => {'label': '$i月', 'value': i})
        .toList();
    _days = generateSolarDays(_year, _month)
        .map((i) => {'label': '$i日', 'value': i})
        .toList();
  }

  void _switchCalendarType(value) {
    setState(() {
      if (CalendarType.lunar == value) {
        _solarToLunar();
        _type = value;
        _centuryController.jumpToItem(centuries.indexOf(_year ~/ 100));
        _yearController.jumpToItem(_year % 100);
        _monthController.jumpToItem(findOptionIndexByValue(_months, _month));
        _dayController.animateToItem(findOptionIndexByValue(_days, _day),
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      }
      if (CalendarType.solar == value) {
        _lunarToSolar();
        _type = value;
        _centuryController.jumpToItem(centuries.indexOf(_year ~/ 100));
        _yearController.jumpToItem(_year % 100);
        _monthController.jumpToItem(findOptionIndexByValue(_months, _month));
        _dayController.animateToItem(findOptionIndexByValue(_days, _day),
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  void jumpToItem(List<int> split) {
    _centuryController.jumpToItem(centuries.indexOf(split[0]));
    _yearController.jumpToItem(findOptionIndexByValue(_years, split[1].toString().padLeft(2, '0')));
    _monthController.jumpToItem(findOptionIndexByValue(_months, split[2]));
    _dayController.jumpToItem(findOptionIndexByValue(_days, split[3]));
    _hourController.jumpToItem(split[4]);
    _minuteController.jumpToItem(split[5]);
  }

  void _onSearch(String value) {
    if (value.isNotEmpty) {
      DateTimeStrParser parser = DateTimeStrParser();
      List<int> split = parser.parseDateTimeString(value);
      if (parser.validateAndSplit(value, context: context)) {
        setState(() {
          _calculateDays();
        });
        jumpToItem(split);
      }
    }
  }

  void initialization() {
    if(widget.value?.value != null) {
      Solar solar = widget.value!.value;
      _year = solar.getYear();
      _month = solar.getMonth();
      _day = solar.getDay();
      _hour = solar.getHour();
      _minute = solar.getMinute();
    }
  }

  @override
  void initState() {
    super.initState();
    initialization();
    _months = generateSolarMonths(_year)
        .map((i) => {'label': '$i月', 'value': i})
        .toList();
    _days = generateSolarDays(_year, _month)
        .map((i) => {'label': '$i日', 'value': i})
        .toList();
    _centuryController = FixedExtentScrollController(
      initialItem: centuries.indexOf(_year ~/ 100),
    );
    _yearController = FixedExtentScrollController(
      initialItem: _year % 100,
    );
    _monthController = FixedExtentScrollController(
      initialItem: findOptionIndexByValue(_months, _month),
    );
    _dayController = FixedExtentScrollController(
      initialItem: findOptionIndexByValue(_days, _day),
    );
    _hourController = FixedExtentScrollController(
      initialItem: _hour,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _minute,
    );
  }

  @override
  void dispose() {
    _centuryController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          title: CapsuleTab<CalendarType>(
            constraints: BoxConstraints(
              minWidth: 300.w,
              maxWidth: 300.w,
            ),
            options: const [
              {'label': '公历', 'value': CalendarType.solar},
              {'label': '农历', 'value': CalendarType.lunar},
            ],
            value: _type,
            onChange: _switchCalendarType,
          ),
          onConfirm: () {
            if(CalendarType.solar == _type) {
              Solar solar = Solar.fromYmdHms(_year, _month, _day, _hour, _minute, 0);
              widget.onChange?.call(Calendar(type: CalendarType.solar, value: solar));
            }
            if(CalendarType.lunar == _type) {
              Lunar lunar = Lunar.fromYmdHms(_year, _month, _day, _hour, _minute, 0);
              widget.onChange?.call(Calendar(type: CalendarType.lunar, value: lunar.getSolar()));
            }
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 48.w),
        Visibility(
          visible: CalendarType.solar == _type,
          child: Padding(
            padding: EdgeInsets.only(bottom: 48.w),
            child: SheetSearchBar(
              placeholder: '请输入时间，如：202311011230',
              keyboardType: TextInputType.number,
              onSearch: _onSearch,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Picker(
                  value: _year ~/ 100,
                  options: _centuries,
                  controller: _centuryController,
                  onChange: (value) {
                    setState(() {
                      _year = value * 100 + _year % 100;
                      _calculateLunarMonths(_year);
                    });
                  },
                ),
              ),
              Expanded(
                child: Picker(
                  looping: true,
                  value: '${_year % 100}'.padLeft(2, '0'),
                  options: _years,
                  controller: _yearController,
                  onChange: (value) {
                    setState(() {
                      _year = _year ~/ 100 * 100 + int.parse(value);
                      _calculateLunarMonths(_year);
                    });
                  },
                ),
              ),
              Expanded(
                child: Picker(
                  looping: true,
                  value: _month,
                  options: _months,
                  controller: _monthController,
                  onChange: (value) {
                    setState(() {
                      _month = value;
                    });
                    _calculateDays();
                  },
                ),
              ),
              Expanded(
                child: Picker(
                  looping: true,
                  value: _day,
                  options: _days,
                  controller: _dayController,
                  onChange: (value) {
                    setState(() {
                      _day = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Picker(
                  looping: true,
                  value: _hour,
                  options: _hours,
                  controller: _hourController,
                  onChange: (value) {
                    setState(() {
                      _hour = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Picker(
                  looping: true,
                  value: _minute,
                  options: _minutes,
                  controller: _minuteController,
                  onChange: (value) {
                    setState(() {
                      _minute = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
