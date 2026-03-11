import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/utils/copy_database.dart';
import 'package:horosa/models/country.dart';
import 'single_picker.dart';

class CountryPicker extends StatefulWidget {
  const CountryPicker({super.key, this.value, this.onChange, this.label});

  final int? value;
  final void Function(Country)? onChange;
  final String? label;

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<Country> _countries = [];
  int _countryId = 45;
  String _countryCNName = '中国';
  late FixedExtentScrollController _controller;

  void loadCountries() async {
    var countries = (await getCountries());
    setState(() {
      _countries =
          countries.map((country) => Country.fromJson(country)).toList();
      _countryCNName = _countries
          .firstWhere((element) => element.id == (widget.value ?? _countryId))
          .cnName;
      _controller.jumpToItem(_countries
          .indexWhere((element) => element.id == (widget.value ?? _countryId)));
    });
  }

  @override
  initState() {
    super.initState();
    loadCountries();
    _controller = FixedExtentScrollController();
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
        SinglePicker(
          controller: _controller,
          options: _countries,
          value: _countryId,
          mapper: (option) {
            return PickerItem(label: option.cnName, value: option.id);
          },
          onChange: (country) {
            setState(() {
              _countryId = country.id;
              _countryCNName = country.cnName;
              widget.onChange?.call(country);
            });
          },
        ).show(context);
      },
      child: Row(
        children: [
          Text(
            widget.label ?? _countryCNName,
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
      ),
    );
  }
}
