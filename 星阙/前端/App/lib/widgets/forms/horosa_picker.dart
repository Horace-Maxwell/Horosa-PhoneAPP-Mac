import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/picker.dart';

class HorosaPicker<T> extends StatefulWidget {
  const HorosaPicker({
    super.key,
    required this.options,
    this.value,
    this.mapper,
    this.looping,
    this.controller,
    this.onChange,
  });

  /// picker 项
  final List<T> options;

  /// 选中值
  final dynamic value;

  /// 函数，映射 T 到 PickerItem
  final PickerItem Function(T option)? mapper;

  /// looping
  final bool? looping;

  /// 回调
  final void Function(T value, PickerItem item)? onChange;

  /// controller
  final FixedExtentScrollController? controller;

  @override
  State<HorosaPicker<T>> createState() => _HorosaPickerState<T>();
}

class _HorosaPickerState<T> extends State<HorosaPicker<T>> {
  late FixedExtentScrollController _controller;
  late int _selectedItemIndex;
  late dynamic _value;

  void _onSelectedItemChanged(int index) {
    PickerItem newValue = widget.mapper != null
        ? widget.mapper!(widget.options[index])
        : _defaultMapper(widget.options[index] as Map<String, dynamic>);

    if (newValue.value != _value) {
      widget.onChange?.call(widget.options[index], newValue);
      setState(() {
        _value = newValue.value;
      });
    }
    HapticFeedback.lightImpact();
  }

  PickerItem _defaultMapper(Map<String, dynamic> option) {
    return PickerItem(
      label: option['label'] as String,
      value: option['value'],
    );
  }

  int _initializeSelectedIndex() {
    _value = widget.value;
    for (int i = 0; i < widget.options.length; i++) {
      final PickerItem item = widget.mapper != null
          ? widget.mapper!(widget.options[i])
          : _defaultMapper(widget.options[i] as Map<String, dynamic>);
      if (item.value == _value) {
        return i;
      }
    }
    return 0; // Fallback to the first item if no match is found
  }
  
  @override
  void initState() {
    super.initState();
    _selectedItemIndex = _initializeSelectedIndex();
    _controller = FixedExtentScrollController(initialItem: _selectedItemIndex);
  }

  @override
  void didUpdateWidget(covariant HorosaPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.value != widget.value) {
      _selectedItemIndex = _initializeSelectedIndex();
      _controller = FixedExtentScrollController(initialItem: _selectedItemIndex);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListWheelScrollView.useDelegate(
            itemExtent: 43.w,
            diameterRatio: 1.6,
            squeeze: 0.75,
            onSelectedItemChanged: _onSelectedItemChanged,
            controller: widget.controller ?? _controller,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: widget.looping ?? false
                ? _buildLoopingPicker(items: widget.options, value: _value, mapper: widget.mapper)
                : _buildNonLoopingPicker(items: widget.options, value: _value, mapper: widget.mapper),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.5, 1],
                  colors: [
                    const Color(0xffffffff).withOpacity(0.75),
                    const Color(0xffffffff).withOpacity(0),
                    const Color(0xffffffff).withOpacity(0.75),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

ListWheelChildDelegate _buildLoopingPicker<T>({
  required List<T> items,
  dynamic value,
  PickerItem Function(T option)? mapper,
}) {
  return ListWheelChildLoopingListDelegate(
    children: List.generate(
      items.length,
          (index) {
        PickerItem item = mapper != null
            ? mapper(items[index])
            : PickerItem(
          label: (items[index] as Map<String, dynamic>)['label'] as String,
          value: (items[index] as Map<String, dynamic>)['value'],
        );
        bool selected = item.value == value;
        return _buildListItem(item: item, selected: selected);
      },
    ),
  );
}

ListWheelChildDelegate _buildNonLoopingPicker<T>({
  required List<T> items,
  dynamic value,
  PickerItem Function(T option)? mapper,
}) {
  return ListWheelChildBuilderDelegate(
    childCount: items.length,
    builder: (context, index) {
      PickerItem item = mapper != null
          ? mapper(items[index])
          : PickerItem(
        label: (items[index] as Map<String, dynamic>)['label'] as String,
        value: (items[index] as Map<String, dynamic>)['value'],
      );
      bool selected = item.value == value;
      return _buildListItem(item: item, selected: selected);
    },
  );
}

Widget _buildListItem({required PickerItem item, required bool selected}) {
  return Text(
    item.label,
    style: TextStyle(
      color: selected ? const Color(0xff222426) : const Color(0x64222426),
      fontSize: 30.sp,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
    ),
  );
}