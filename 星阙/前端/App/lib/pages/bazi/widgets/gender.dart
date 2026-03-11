import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/gender.dart';
import 'package:horosa/widgets/forms/forms.dart';

class GenderRadioGroup extends StatelessWidget {
  const GenderRadioGroup({super.key, required this.value, this.onChange});
  final Gender value;
  final Function(Gender)? onChange;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HorosaRadio<Gender>(
            label: '男',
            value: Gender.male,
            checked: Gender.male == value,
            onChange: onChange,
          ),
          SizedBox(width: 80.w),
          HorosaRadio<Gender>(
            label: '女',
            value: Gender.female,
            checked: Gender.female == value,
            onChange: onChange,
          ),
        ],
      ),
    );
  }
}