import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/widgets/capsule_tab.dart';
import 'package:horosa/widgets/chn_place_picker.dart';
import 'package:horosa/widgets/map_picker.dart';
import 'bottom_sheet_header.dart';

enum PickerType { map, select }

class PlacePicker extends StatefulWidget {
  const PlacePicker({super.key, this.onChange, this.value});

  final CHNPlaceAdcode? value;
  final Function(CHNPlace?)? onChange;

  void show(context, [double? height]) {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffffffff),
      builder: (context) => this,
    );
  }

  @override
  State<PlacePicker> createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  PickerType _type = PickerType.select;
  CHNPlace? _place;

  void initialize() {
    setState(() {
      if (widget.value != null) {
        CHNPlace place = CHNPlace.fromAdcode(widget.value!);
        _place = place;
      } else {
        _place = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    final pickerOptions = LocalMode.enabled
        ? const [
            {'label': '选择', 'value': PickerType.select},
          ]
        : const [
            {'label': '选择', 'value': PickerType.select},
            {'label': '地图', 'value': PickerType.map},
          ];
    return StatefulBuilder(builder: (context, setState) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: PickerType.select == _type ? 693.w : 0.88.sh,
          minHeight: PickerType.select == _type ? 693.w : 0.88.sh,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(72.r),
            topRight: Radius.circular(72.r),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 36.w, top: 56.w, right: 36.w, bottom: 0),
                child: BottomSheetHeader(
                  onConfirm: () {
                    widget.onChange?.call(_place);
                    Navigator.pop(context);
                  },
                  title: SizedBox(
                    width: 300.w,
                    child: CapsuleTab(
                      options: pickerOptions,
                      onChange: (val) {
                        setState(() {
                          _type = val;
                        });
                      },
                      value: _type,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 36.w),
              Visibility(
                visible: !LocalMode.enabled && PickerType.map == _type,
                child: Expanded(
                  child: MapPicker(
                    onChange: (location) {
                      setState(() {
                        _place = CHNPlace.fromAdcode(
                          CHNPlaceAdcode(
                            province: int.parse('${location.pcode}00'),
                            city: int.parse(
                                '${'${location.adcode}'.substring(0, 4)}0000'),
                            county: int.parse('${location.adcode}00'),
                          ),
                        );
                        Log.d('选择地点：$_place');
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: PickerType.select == _type,
                child: Expanded(
                  child: CHNPlacePicker(
                    value: _place,
                    onChange: (place) {
                      setState(() {
                        _place = place;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
