import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horosa/models/calendar.dart';
import 'package:horosa/models/horosa.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/utils/utils.dart';
import 'package:lunar/lunar.dart';
import 'bottom_sheet_header.dart';

enum PillarInputType {
  yearStems,
  yearBranch,
  monthPillar,
  dayStems,
  dayBranch,
  hourPillar
}

class FourPillarsPicker extends StatefulWidget {
  const FourPillarsPicker({super.key, this.value, this.onChange});

  final Calendar? value;

  final void Function(Calendar)? onChange;

  void show(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(72.r),
          topRight: Radius.circular(72.r),
        ),
        child: BottomSheet(
          enableDrag: false,
          showDragHandle: false,
          backgroundColor: const Color(0xffffffff),
          onClosing: () {},
          constraints: BoxConstraints(
            minWidth: 1.sw,
            maxHeight: 828.w,
            minHeight: 828.w,
          ),
          builder: (context) => this,
        ),
      ),
    );
  }

  @override
  State<FourPillarsPicker> createState() => _FourPillarsPickerState();
}

class _FourPillarsPickerState extends State<FourPillarsPicker> {
  List<StemsBranchItem> pillars =
      List.generate(4, (index) => const StemsBranchItem());
  List<StemsBranchItem?> items = StemsAndBranches.getStemsByStemsBranchItem();
  PillarInputType _pillarInputType = PillarInputType.yearStems;
  Solar? dateOfPillar;
  String label = '请选择年干';

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      Lunar lunar = widget.value!.value.getLunar();

      pillars[0] = StemsBranchItem(
          stems:
              StemsAndBranches.getElementByLabel(lunar.getYearGan()) as Stems,
          branch: StemsAndBranches.getElementByLabel(lunar.getYearZhi())
              as Branches);
      pillars[1] = StemsBranchItem(
          stems:
              StemsAndBranches.getElementByLabel(lunar.getMonthGan()) as Stems,
          branch: StemsAndBranches.getElementByLabel(lunar.getMonthZhi())
              as Branches);
      pillars[2] = StemsBranchItem(
          stems: StemsAndBranches.getElementByLabel(lunar.getDayGan()) as Stems,
          branch: StemsAndBranches.getElementByLabel(lunar.getDayZhi())
              as Branches);
      pillars[3] = StemsBranchItem(
          stems:
              StemsAndBranches.getElementByLabel(lunar.getTimeGan()) as Stems,
          branch: StemsAndBranches.getElementByLabel(lunar.getTimeZhi())
              as Branches);
      label = '请选择出生时间';
      _pillarInputType = PillarInputType.hourPillar;
      dateOfPillar = widget.value!.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 36.w, top: 56.w, right: 36.w),
      child: Column(
        children: [
          BottomSheetHeader(
            title: Container(
              width: 150.w,
              height: 48.w,
              decoration: ShapeDecoration(
                color: const Color(0xff222426),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: Center(
                child: Text(
                  '四柱',
                  style: TextStyle(
                    color: const Color(0xfff8cc76),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            onConfirm: () {
              if (dateOfPillar != null) {
                widget.onChange?.call(
                    Calendar(type: CalendarType.pillars, value: dateOfPillar!));
                Navigator.pop(context);
              } else {
                toast(
                  '请先完成各项选择！',
                  context: context,
                );
              }
            },
          ),
          SizedBox(height: 52.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FourPillarItem<PillarInputType>(
                label: '年柱',
                value: pillars[0],
                stemKey: PillarInputType.yearStems,
                branchKey: PillarInputType.yearBranch,
                selectedKey: _pillarInputType,
                onStemFocus: (key) {
                  setState(() {
                    _pillarInputType = key;
                    items = StemsAndBranches.getStemsByStemsBranchItem();
                    label = '请选择年干';
                    dateOfPillar = null;
                  });
                },
                onBranchFocus: (key) {
                  setState(() {
                    if (pillars[0].stems != null) {
                      _pillarInputType = key;
                      items = SixtyAZi.getBranchesByStems(pillars[0].stems!);
                      label = '请选择年支';
                      dateOfPillar = null;
                    }
                  });
                },
              ),
              FourPillarItem(
                label: '月柱',
                value: pillars[1],
                stemKey: PillarInputType.monthPillar,
                branchKey: PillarInputType.monthPillar,
                selectedKey: _pillarInputType,
                onStemFocus: (key) {
                  setState(() {
                    if (pillars[0].branch != null) {
                      _pillarInputType = key;
                      items =
                          StemsAndBranches.getMonthPillars(pillars[0].stems!);
                      label = '请选择月柱';
                      dateOfPillar = null;
                    }
                  });
                },
                onBranchFocus: (key) {
                  setState(() {
                    if (pillars[0].branch != null) {
                      _pillarInputType = key;
                      items =
                          StemsAndBranches.getMonthPillars(pillars[0].stems!);
                      label = '请选择月柱';
                      dateOfPillar = null;
                    }
                  });
                },
              ),
              FourPillarItem(
                label: '日柱',
                value: pillars[2],
                stemKey: PillarInputType.dayStems,
                branchKey: PillarInputType.dayBranch,
                selectedKey: _pillarInputType,
                onStemFocus: (key) {
                  setState(() {
                    if (pillars[1].branch != null) {
                      _pillarInputType = key;
                      items = StemsAndBranches.getStemsByStemsBranchItem();
                      label = '请选择日干';
                      dateOfPillar = null;
                    }
                  });
                },
                onBranchFocus: (key) {
                  setState(() {
                    if (pillars[2].stems != null) {
                      _pillarInputType = key;
                      items = SixtyAZi.getBranchesByStems(pillars[2].stems!);
                      label = '请选择日支';
                      dateOfPillar = null;
                    }
                  });
                },
              ),
              FourPillarItem(
                label: '时柱',
                value: pillars[3],
                stemKey: PillarInputType.hourPillar,
                branchKey: PillarInputType.hourPillar,
                selectedKey: _pillarInputType,
                onStemFocus: (key) {
                  setState(() {
                    if (pillars[2].branch != null) {
                      _pillarInputType = key;
                      items =
                          StemsAndBranches.getHourPillars(pillars[2].stems!);
                      label = '请选择时柱';
                      dateOfPillar = null;
                    }
                  });
                },
                onBranchFocus: (key) {
                  setState(() {
                    if (pillars[2].branch != null) {
                      _pillarInputType = key;
                      items =
                          StemsAndBranches.getHourPillars(pillars[2].stems!);
                      label = '请选择时柱';
                      dateOfPillar = null;
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 40.w),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xfff8f8f8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pillars = List.generate(
                                  4, (index) => const StemsBranchItem());
                              _pillarInputType = PillarInputType.yearStems;
                              items =
                                  StemsAndBranches.getStemsByStemsBranchItem();
                              label = '请选择年干';
                              dateOfPillar = null;
                            });
                          },
                          child: Text(
                            '清空',
                            style: TextStyle(
                              color: const Color(0xfff1ac62),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xfff1ac62),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 42.w),
                    pillars[3].branch != null &&
                            _pillarInputType == PillarInputType.hourPillar &&
                            label == '请选择出生时间'
                        ? Expanded(
                            child: DateOfBirths(
                              selectedItem: dateOfPillar,
                              pillars: pillars,
                              onChange: (val) {
                                setState(() {
                                  dateOfPillar = val;
                                });
                              },
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              double width = constraints.maxWidth;
                              return Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                spacing: (width - ((items.length / 2) * 80.w)) /
                                    (items.length / 2),
                                runSpacing: 24.w,
                                children: items
                                    .map(
                                      (item) => Pillar(
                                        pillar: item ?? const StemsBranchItem(),
                                        onChange: (pillar) {
                                          setState(
                                            () {
                                              if (_pillarInputType ==
                                                  PillarInputType.yearStems) {
                                                pillars = List.generate(
                                                    4,
                                                    (_) =>
                                                        const StemsBranchItem());
                                                pillars[0] = StemsBranchItem(
                                                    stems: pillar.stems,
                                                    branch: null);
                                                _pillarInputType =
                                                    PillarInputType.yearBranch;
                                                items =
                                                    SixtyAZi.getBranchesByStems(
                                                        pillar.stems!);
                                                label = '请选择年支';
                                                return;
                                              }
                                              if (_pillarInputType ==
                                                  PillarInputType.yearBranch) {
                                                pillars[0] = StemsBranchItem(
                                                    stems: pillars[0].stems,
                                                    branch: pillar.branch);
                                                pillars[1] =
                                                    const StemsBranchItem();
                                                pillars[2] =
                                                    const StemsBranchItem();
                                                pillars[3] =
                                                    const StemsBranchItem();
                                                _pillarInputType =
                                                    PillarInputType.monthPillar;
                                                items = StemsAndBranches
                                                    .getMonthPillars(
                                                        pillars[0].stems!);
                                                label = '请选择月柱';
                                                return;
                                              }
                                              if (_pillarInputType ==
                                                  PillarInputType.monthPillar) {
                                                pillars[1] = StemsBranchItem(
                                                    stems: pillar.stems,
                                                    branch: pillar.branch);
                                                pillars[2] =
                                                    const StemsBranchItem();
                                                pillars[3] =
                                                    const StemsBranchItem();
                                                _pillarInputType =
                                                    PillarInputType.dayStems;
                                                items = StemsAndBranches
                                                    .getStemsByStemsBranchItem();
                                                label = '请选择日干';
                                                return;
                                              }
                                              if (_pillarInputType ==
                                                  PillarInputType.dayStems) {
                                                pillars[2] = StemsBranchItem(
                                                    stems: pillar.stems,
                                                    branch: null);
                                                pillars[3] =
                                                    const StemsBranchItem();
                                                _pillarInputType =
                                                    PillarInputType.dayBranch;
                                                items =
                                                    SixtyAZi.getBranchesByStems(
                                                        pillar.stems!);
                                                label = '请选择日支';
                                                return;
                                              }
                                              if (_pillarInputType ==
                                                  PillarInputType.dayBranch) {
                                                pillars[2] = StemsBranchItem(
                                                    stems: pillars[2].stems,
                                                    branch: pillar.branch);
                                                pillars[3] =
                                                    const StemsBranchItem();
                                                _pillarInputType =
                                                    PillarInputType.hourPillar;
                                                items = StemsAndBranches
                                                    .getHourPillars(
                                                        pillars[2].stems!);
                                                label = '请选择时柱';
                                                return;
                                              }
                                              if (_pillarInputType ==
                                                  PillarInputType.hourPillar) {
                                                pillars[3] = StemsBranchItem(
                                                    stems: pillar.stems,
                                                    branch: pillar.branch);
                                                label = '请选择出生时间';
                                                return;
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DateOfBirths extends StatefulWidget {
  const DateOfBirths(
      {super.key, required this.pillars, this.selectedItem, this.onChange});

  final List<StemsBranchItem> pillars;
  final void Function(Solar)? onChange;
  final Solar? selectedItem;

  @override
  State<DateOfBirths> createState() => _DateOfBirthsState();
}

class _DateOfBirthsState extends State<DateOfBirths> {
  List<Solar> dates = [];

  String solarToString(Solar date) {
    int year = date.getYear();
    String month = date.getMonth().toString().padLeft(2, '0');
    String day = date.getDay().toString().padLeft(2, '0');
    String hour = date.getHour().toString().padLeft(2, '0');
    String minute = date.getMinute().toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  String lunarToString(Solar date) {
    Lunar lunar = date.getLunar();
    String year = lunar.getYearInChinese();
    String month = lunar.getMonthInChinese();
    String day = lunar.getDayInChinese();
    String hour = lunar.getHour().toString().padLeft(2, '0');
    String minute = lunar.getMinute().toString().padLeft(2, '0');
    return '$year年$month月$day $hour:$minute';
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      StemsBranchItem year = widget.pillars[0];
      String yearBI = (year.stems?.label ?? '') + (year.branch?.label ?? '');
      StemsBranchItem month = widget.pillars[1];
      String monthBI = (month.stems?.label ?? '') + (month.branch?.label ?? '');
      StemsBranchItem day = widget.pillars[2];
      String dayBI = (day.stems?.label ?? '') + (day.branch?.label ?? '');
      StemsBranchItem hour = widget.pillars[3];
      String hourBI = (hour.stems?.label ?? '') + (hour.branch?.label ?? '');
      dates =
          calcSolarListByBaZi(yearBI, monthBI, dayBI, hourBI).reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onChange?.call(dates[index]);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.w),
            decoration: ShapeDecoration(
              color: widget.selectedItem != null &&
                      widget.selectedItem?.getYear() == dates[index].getYear()
                  ? const Color(0xff222426)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.w,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: const Color(0xffcccccc),
                ),
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '阳历：${solarToString(dates[index])}',
                  style: TextStyle(
                    color: widget.selectedItem != null &&
                            widget.selectedItem?.getYear() ==
                                dates[index].getYear()
                        ? const Color(0xfff8cc76)
                        : const Color(0xff222426),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  '阴历：${lunarToString(dates[index])}',
                  style: TextStyle(
                    color: widget.selectedItem != null &&
                            widget.selectedItem?.getYear() ==
                                dates[index].getYear()
                        ? const Color(0xfff8cc76)
                        : const Color(0xff222426),
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class FourPillarItem<T> extends StatelessWidget {
  const FourPillarItem({
    super.key,
    required this.label,
    this.value,
    this.stemKey,
    this.branchKey,
    this.selectedKey,
    this.onStemFocus,
    this.onBranchFocus,
  });

  final String label;
  final StemsBranchItem? value;
  final T? stemKey;
  final T? branchKey;
  final T? selectedKey;
  final void Function(T)? onStemFocus;
  final void Function(T)? onBranchFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 20.w),
        GestureDetector(
          onTap: () {
            if (stemKey != null) {
              onStemFocus?.call(stemKey as T);
            }
          },
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width: stemKey != null && stemKey == selectedKey ? 4.w : 2.w,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: stemKey != null && stemKey == selectedKey
                      ? const Color(0xfff1ac62)
                      : const Color(0xffcccccc),
                ),
              ),
            ),
            child: Center(
              child: Text(
                value?.stems?.label ?? '',
                style: TextStyle(
                  color: value?.stems?.element.color ?? const Color(0xff222426),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.w),
        GestureDetector(
          onTap: () {
            if (branchKey != null) {
              onBranchFocus?.call(branchKey as T);
            }
          },
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: ShapeDecoration(
              shape: OvalBorder(
                side: BorderSide(
                  width:
                      branchKey != null && branchKey == selectedKey ? 4.w : 2.w,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: branchKey != null && branchKey == selectedKey
                      ? const Color(0xfff1ac62)
                      : const Color(0xffcccccc),
                ),
              ),
            ),
            child: Center(
              child: Text(
                value?.branch?.label ?? '',
                style: TextStyle(
                  color:
                      value?.branch?.element.color ?? const Color(0xff222426),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Pillar extends StatelessWidget {
  const Pillar({super.key, required this.pillar, this.onChange});

  final StemsBranchItem pillar;
  final Function(StemsBranchItem)? onChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange?.call(pillar);
      },
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: ShapeDecoration(
          shape: OvalBorder(
            side: BorderSide(
              width: 2.w,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: const Color(0xffcccccc),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: pillar.stems != null,
              child: Text(
                pillar.stems?.label ?? '',
                style: TextStyle(
                  color: pillar.stems != null
                      ? pillar.stems!.element.color
                      : Colors.transparent,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Visibility(
              visible: pillar.branch != null,
              child: Text(
                pillar.branch?.label ?? '',
                style: TextStyle(
                  color: pillar.branch != null
                      ? pillar.branch!.element.color
                      : Colors.transparent,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
