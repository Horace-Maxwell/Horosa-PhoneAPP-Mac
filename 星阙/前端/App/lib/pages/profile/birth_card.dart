import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/widgets/chn_place_picker.dart';

import 'edit_user_info.dart';

class BirthCard extends StatefulWidget {
  const BirthCard({super.key, required this.data, this.onDelete, this.onRefresh});

  final Relation data;
  final void Function(int)? onDelete;
  final void Function()? onRefresh;

  @override
  State<BirthCard> createState() => _ArchiveCardState();
}

class _ArchiveCardState extends State<BirthCard>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: Slidable(
        key: ValueKey(widget.data.id),
        controller: controller,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 328.w / (1.sw - 72.w),
          children: [
            GestureDetector(
              onTap: () async {
                controller.close();
                final result = await Navigator.of(context).pushNamed(EditUserInfoPage.route,
                    arguments: EditUserInfoForm(
                      type: EditUserInfoType.edit,
                      payload: widget.data,
                    ));
                if (result != null && result is Map && result['refresh'] == true) {
                  widget.onRefresh?.call();
                }
              },
              child: Container(
                width: 158.w,
                decoration: ShapeDecoration(
                  color: const Color(0xffe5e5e5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    '编辑',
                    style: TextStyle(
                      color: const Color(0xff222426),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onDelete?.call(widget.data.id!);
                controller.close();
              },
              child: Container(
                width: 158.w,
                decoration: ShapeDecoration(
                  color: const Color(0xffbd1a0b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    '删除',
                    style: TextStyle(
                      color: const Color(0xffffffff),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.w),
          decoration: ShapeDecoration(
            color: const Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.r),
            ),
            shadows: [
              BoxShadow(
                color: const Color(0x13222327),
                blurRadius: 12.r,
                offset: Offset(0, 8.w),
                spreadRadius: -4.r,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.name,
                style: TextStyle(
                  color: const Color(0xff222426),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 30.w),
              Text(
                '''${widget.data.birthday}   ${CHNPlaceLoader.instance.getPlaceFromAdcode(CHNPlaceAdcode(
                      province: widget.data.birthProvinceId,
                      city: widget.data.birthCityId,
                      county: widget.data.birthDistrictId,
                    )).toFullString()}''',
                style: TextStyle(
                  color: const Color(0xff88898d),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
