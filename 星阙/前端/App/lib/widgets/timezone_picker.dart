import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/country.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/utils/copy_database.dart';
import 'package:horosa/models/timezone.dart';
import 'single_picker.dart';

class TimeZonePicker extends StatefulWidget {
  const TimeZonePicker(
      {super.key, required this.value, this.onChange, required this.countryId});

  final String value;
  final int countryId;
  final void Function(TimeZone)? onChange;

  @override
  State<TimeZonePicker> createState() => _TimeZonePickerState();
}

class _TimeZonePickerState extends State<TimeZonePicker> {
  List<TimeZone> _timezones = [];
  String _value = '亚洲/北京';
  String _gmtOffsetName = 'UTC+08:00';
  late FixedExtentScrollController _controller;

  void loadTimezones() async {
    var countries = (await getCountries());
    setState(() {
      _value = widget.value;
      Country country = countries
          .map((country) => Country.fromJson(country))
          .firstWhere((element) => element.id == widget.countryId);
      _timezones = country.timezones;
      _gmtOffsetName = _timezones.firstWhere((element) => element.zoneName == widget.value).gmtOffsetName;
      _controller.jumpToItem(
          _timezones.indexWhere((element) => element.zoneName == widget.value));
    });
  }

  @override
  initState() {
    super.initState();
    loadTimezones();
    _controller = FixedExtentScrollController();
  }

  @override
  void didUpdateWidget(covariant TimeZonePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.countryId != widget.countryId) {
      loadTimezones();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SinglePicker<TimeZone>(
          controller: _controller,
          options: _timezones,
          value: _value,
          mapper: (option) {
            return PickerItem(
              label: '${option.zoneName} ${option.gmtOffsetName}',
              value: option.zoneName,
            );
          },
          onChange: (timezone) {
            setState(() {
              _value = timezone.zoneName;
              _gmtOffsetName = timezone.gmtOffsetName;
              widget.onChange?.call(timezone);
            });
          },
        ).show(context);
      },
      child: Row(
        children: [
          Text(
            _gmtOffsetName,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xff222426),
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: SvgPicture.asset(
              'assets/icons/arrow-down-fill.svg',
              width: 24.w,
              height: 24.w,
            ),
          )
        ],
      )
    );
  }
}
