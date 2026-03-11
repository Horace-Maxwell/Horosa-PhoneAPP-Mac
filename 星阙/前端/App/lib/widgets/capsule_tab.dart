import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Item<T> {
  final String label;
  final T value;

  const Item({required this.label, required this.value});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      label: json['label'],
      value: json['value'],
    );
  }
}

class CapsuleTab<T> extends StatelessWidget {
  const CapsuleTab(
      {super.key,
      required this.options,
      required this.value,
      this.onChange,
      this.itemExtent,
      this.constraints});

  final List<Map<String, dynamic>> options;

  final T value;

  final void Function(T)? onChange;

  final BoxConstraints? constraints;

  final double? itemExtent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        height: itemExtent ?? 48.w,
        constraints: constraints,
        decoration: BoxDecoration(
          color: const Color(0xff222426),
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          children:
              _buildTabs(options: options, value: value, onChange: onChange),
        ),
      ),
    );
  }
}

List<Widget> _buildTabs<T>(
    {required List<Map<String, dynamic>> options,
    required T value,
    void Function(T)? onChange}) {
  List<Item<T>> items = options.map((item) => Item<T>.fromJson(item)).toList();

  return List.generate(items.length, (index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onChange?.call(items[index].value);
        },
        child: Padding(
          padding: EdgeInsets.all(2.r),
          child: Container(
            decoration: ShapeDecoration(
              color: value == items[index].value
                  ? const Color(0xff222426)
                  : const Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: index == 0 ? Radius.circular(999.r) : Radius.zero,
                  bottomLeft: index == 0 ? Radius.circular(999.r) : Radius.zero,
                  topRight: index == items.length - 1
                      ? Radius.circular(999.r)
                      : Radius.zero,
                  bottomRight: index == items.length - 1
                      ? Radius.circular(999.r)
                      : Radius.zero,
                ),
              ),
            ),
            child: Center(
              child: Text(
                items[index].label,
                style: TextStyle(
                  color: value == items[index].value
                      ? const Color(0xfff8cc76)
                      : const Color(0xff222426),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}
