import 'dart:async';

typedef VoidCallback = void Function();

VoidCallback debounce(VoidCallback callback, [int milliseconds = 500]) {
  Timer? timer;

  return () {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), callback);
  };
}
