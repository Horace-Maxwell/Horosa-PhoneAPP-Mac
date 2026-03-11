class IntervalFiller {
  final int n;
  List<List<int>> intervals;
  Map<String, int>? indices = {};  // 使用字符串作为键

  IntervalFiller(this.n, this.intervals, [this.indices]);

  IntervalFiller fillIntervalsWithIndex() {
    List<List<int>> filledIntervals = [];
    Map<String, int> indexMap = {};
    int start = 1;
    int filledIndex = 0;

    // 对区间进行排序
    intervals.sort((a, b) => a[0].compareTo(b[0]));

    // 遍历并填充区间
    for (List<int> interval in intervals) {
      int begin = interval[0];
      int end = interval[1];

      if (start < begin) {
        filledIntervals.add([start, begin - 1]);
        filledIndex++;
      }

      filledIntervals.add(interval);
      indexMap[interval.toString()] = filledIndex;
      filledIndex++;
      start = end + 1;
    }

    // 检查末尾是否需要填充
    if (start <= n) {
      filledIntervals.add([start, n]);
    }

    // 创建新的IntervalFiller实例，包括新区间和原始区间在结果中的索引
    return IntervalFiller(n, filledIntervals, indexMap);
  }

  @override
  String toString() {
    return 'Intervals: $intervals\nIndices: $indices';
  }
}

// void main() {
//   var filler = IntervalFiller(11, [[1, 3], [5, 7], [9, 11]]);
//   var newFiller = filler.fillIntervalsWithIndex();
//   print(newFiller);  // 使用toString方法输出详细信息
// }
