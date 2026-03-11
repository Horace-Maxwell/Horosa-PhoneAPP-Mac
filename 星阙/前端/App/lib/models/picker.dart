class PickerItem {
  final String label;
  final dynamic value;

  PickerItem({required this.label, required this.value});

  factory PickerItem.fromJson(Map<String, dynamic> json) {
    return PickerItem(label: json['label'], value: json['value']);
  }
}