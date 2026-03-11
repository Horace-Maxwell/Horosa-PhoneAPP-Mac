import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Item {
  final String label;
  final dynamic value;

  Item({required this.label, required this.value});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(label: json['label'], value: json['value']);
  }
}

class Picker<T> extends StatelessWidget {
  const Picker({
    super.key,
    required this.options,
    required this.value,
    this.looping,
    this.controller,
    this.onChange,
  });

  /// picker 项
  final List<Map<String, dynamic>> options;

  /// 选中值
  final T value;

  /// looping
  final bool? looping;

  /// 回调
  final void Function(T value)? onChange;

  /// controller
  final FixedExtentScrollController? controller;

  void _onSelectedItemChanged(int index) {
    Item newValue = Item.fromJson(options[index]);
    if (newValue.value != value) {
      onChange?.call(newValue.value);
    }
    HapticFeedback.lightImpact();
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
            controller: controller ?? FixedExtentScrollController(),
            physics: const FixedExtentScrollPhysics(),
            childDelegate: looping ?? false
                ? _buildLoopingPicker(items: options, value: value)
                : _buildNonLoopingPicker(items: options, value: value),
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

ListWheelChildDelegate _buildLoopingPicker<T>(
    {required List<Map<String, dynamic>> items, required T value}) {
  return ListWheelChildLoopingListDelegate(
    children: List.generate(
      items.length,
      (index) {
        Item item = Item.fromJson(items[index]);
        bool selected = item.value == value;
        return _buildListItem(item: item, selected: selected);
      },
    ),
  );
}

ListWheelChildDelegate _buildNonLoopingPicker<T>(
    {required List items, required T value}) {
  return ListWheelChildBuilderDelegate(
    childCount: items.length,
    builder: (context, index) {
      Item item = Item.fromJson(items[index]);
      bool selected = item.value == value;
      return _buildListItem(item: item, selected: selected);
    },
  );
}

Widget _buildListItem({required Item item, required bool selected}) {
  return Text(
    item.label,
    style: TextStyle(
      color: selected ? const Color(0xff222426) : const Color(0x64222426),
      fontSize: 30.sp,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
    ),
  );
}
