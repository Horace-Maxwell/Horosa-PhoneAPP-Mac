int findOptionIndexByValue<T>(List<Map<String, dynamic>> arr, T value) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i]['value'] == value) {
      return i;
    }
  }
  return -1;
}