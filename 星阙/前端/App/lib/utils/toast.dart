import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

void toast(String msg, {Duration? duration, BuildContext? context}) {
  toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.simple,
    title: Text(
      msg,
      style: const TextStyle(
        color: Color(0xffffffff),
        fontFamily: 'SourceHanSansCN',
      ),
    ),
    alignment: Alignment.center,
    autoCloseDuration: duration ?? const Duration(seconds: 2),
    backgroundColor: const Color(0xff000000),
    foregroundColor: const Color(0xffffffff),
    borderSide: BorderSide.none,
    closeButtonShowType: CloseButtonShowType.none,
    closeOnClick: true,
    showIcon: false,
  );
}
