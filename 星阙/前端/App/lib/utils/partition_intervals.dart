List<List<List<int>>> partitionIntervals(List<List<int>> intervals) {
  // 对区间按结束点排序
  intervals.sort((a, b) => a[1].compareTo(b[1]));

  List<List<List<int>>> piles = [];
  List<List<int>> remainingIntervals = List.from(intervals);

  while (remainingIntervals.isNotEmpty) {
    List<List<int>> currentPile = [];
    int lastEnd = -1;
    List<List<int>> nextRemaining = [];

    for (var interval in remainingIntervals) {
      // 只有当当前区间的开始点大于上一个区间的结束点时，才加入当前堆
      if (interval[0] > lastEnd) {
        currentPile.add(interval);
        lastEnd = interval[1];
      } else {
        nextRemaining.add(interval);
      }
    }

    // 将当前堆添加到结果中
    piles.add(currentPile);
    // 更新剩余区间为未添加到堆中的区间
    remainingIntervals = nextRemaining;
  }

  return piles;
}