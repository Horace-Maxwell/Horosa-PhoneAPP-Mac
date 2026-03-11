import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/widgets/forms/horosa_picker.dart';
import 'bottom_sheet_header.dart';

class SinglePicker<T> extends StatefulWidget {
  const SinglePicker({super.key, this.value, this.onChange, this.mapper, required this.options, this.controller, this.looping, this.height});

  final dynamic value;
  final List<T> options;
  final Function(T)? onChange;
  final PickerItem Function(T option)? mapper;
  final FixedExtentScrollController? controller;
  final bool? looping;
  final double? height;

  void show(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xffffffff),
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
            maxHeight: height ?? 828.w,
            minHeight: height ?? 828.w,
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
  State<SinglePicker<T>> createState() => _SinglePickerState<T>();
}

class _SinglePickerState<T> extends State<SinglePicker<T>> {
  late T _selectItem;

  PickerItem _defaultMapper(Map<String, dynamic> option) {
    return PickerItem(
      label: option['label'] as String,
      value: option['value'],
    );
  }

  int _initializeSelectedIndex() {
    for (int i = 0; i < widget.options.length; i++) {
      final PickerItem item = widget.mapper != null
          ? widget.mapper!(widget.options[i])
          : _defaultMapper(widget.options[i] as Map<String, dynamic>);
      if (item.value == widget.value) {
        return i;
      }
    }
    return 0; // Fallback to the first item if no match is found
  }

  @override
  void initState() {
    super.initState();
    int selectedItemIndex = _initializeSelectedIndex();
    _selectItem = widget.options[selectedItemIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeader(
          onConfirm: () {
            widget.onChange?.call(_selectItem);
            Navigator.pop(context);
          },
        ),
        SizedBox(height: 36.w),
        Expanded(
          child: HorosaPicker<T>(
            options: widget.options,
            value: widget.value,
            mapper: widget.mapper,
            looping: widget.looping,
            onChange: (selectItem, item) {
              setState(() {
                _selectItem = selectItem;
              });
            },
          ),
        ),
      ],
    );
  }
}
