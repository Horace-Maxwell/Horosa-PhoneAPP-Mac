import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/city.dart';
import 'package:horosa/utils/copy_database.dart';
import 'package:horosa/widgets/non_chn_place_list.dart';
import 'package:horosa/widgets/sheet_search_bar.dart';
import 'bottom_sheet_header.dart';

class NonCHNPlacePicker extends StatefulWidget {
  const NonCHNPlacePicker({super.key, required this.countryId, this.onChange});

  final int countryId;
  final void Function(City?)? onChange;

  void show(context) {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffffffff),
      constraints: BoxConstraints(
        maxHeight: 0.88.sh,
        minHeight: 0.88.sh,
      ),
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(72.r),
          topRight: Radius.circular(72.r),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 56.w, bottom: 0),
          child: this,
        ),
      ),
    );
  }

  @override
  State<NonCHNPlacePicker> createState() => _NonCHNPlacePickerState();
}

class _NonCHNPlacePickerState extends State<NonCHNPlacePicker> {
  List<City> _places = [];
  List<City> _cities = [];
  City? _city;
  String text = '';
  FocusNode focusNode = FocusNode();

  void _onSearch(value) {
    setState(() {
      text = value;
      _cities = _places.where((city) => city.name.contains(value)).toList();
    });
  }

  Future<void> initialization() async {
    var cities = (await getCitiesByCountryId(widget.countryId));
    setState(() {
      _places = cities.map((city) => City.fromJson(city)).toList();
      _cities = _places;
    });
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 36.w),
          child: BottomSheetHeader(
            onConfirm: () {
              widget.onChange?.call(_city);
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(height: 36.w),
        Padding(
          padding: EdgeInsets.only(left: 36.w, right: 36.w, bottom: 24.w),
          child: SheetSearchBar(
            placeholder: 'Please enter a city name',
            onSearch: _onSearch,
            value: text,
          ),
        ),
        Expanded(
          child: NonChnPlaceList(
              city: _city,
              onSelected: (city) {
                setState(() {
                  _city = city;
                });
              },
              places:
                  (text.isNotEmpty && _cities.isNotEmpty) ? _cities : _places),
        ),
      ],
    );
  }
}
