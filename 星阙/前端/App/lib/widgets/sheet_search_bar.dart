import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SheetSearchBar extends StatefulWidget {
  const SheetSearchBar({super.key, this.value, this.placeholder, this.keyboardType, this.focusNode, this.maxLength, this.onChange, this.onSearch});

  final String? placeholder;

  final String? value;

  final void Function(String)? onSearch;

  final void Function(String)? onChange;

  final FocusNode? focusNode;

  final int? maxLength;

  final TextInputType? keyboardType;

  @override
  State<SheetSearchBar> createState() => _SheetSearchBarState();
}

class _SheetSearchBarState extends State<SheetSearchBar> {
  final TextEditingController controller = TextEditingController(text: '');

  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value ?? '';
  }

  @override
  void didUpdateWidget(covariant SheetSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.value != widget.value) {
      controller.text = widget.value ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
              height: 60.w,
              child: TextField(
                controller: controller,
                focusNode: widget.focusNode ?? focusNode,
                keyboardType: widget.keyboardType,
                maxLength: widget.maxLength,
                onChanged: widget.onChange,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: widget.placeholder ?? '请输入搜索内容',
                  hintStyle: TextStyle(
                    color: const Color(0x66393b41),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 8.w),
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(60.r),
                    borderSide: BorderSide(
                        width: 1.w, color: const Color(0xff393b41)),
                  ),
                ),
                onSubmitted: widget.onSearch,
              ),
            )),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            if (widget.onSearch != null) {
              widget.onSearch?.call(controller.text);
            }
            focusNode.unfocus();
          },
          child: Container(
            width: 106.w,
            height: 60.w,
            decoration: ShapeDecoration(
              color: const Color(0xff222426),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: const Color(0xff393b41)),
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Center(
              child: Text(
                '搜索',
                style: TextStyle(
                  color: const Color(0xfff8cc76),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
