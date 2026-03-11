List<T> cyclicSort<T>(List<T> list, int startIndex, int length) {
  if (list.length < startIndex) {
    throw ArgumentError('RangeError: Index Out of Bounds.');
  }

  // 构建新的周期性排序后的列表
  List<T> sortedList = [];
  for (int i = 0; i < length; i++) {
    int index = (startIndex + i) % list.length;
    sortedList.add(list[index]);
  }

  return sortedList;
}