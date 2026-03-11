import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/picker.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/providers/config.dart';
import 'package:horosa/services/archive.dart';
import 'package:horosa/services/log.dart';
import 'package:horosa/services/profile.dart';
import 'package:horosa/utils/apparent_solar_time.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/widgets/chn_place_picker.dart';
import 'package:lunar/lunar.dart';
import 'package:provider/provider.dart';
import 'package:horosa/models/bazi.dart';
import 'package:horosa/models/calendar.dart';
import 'package:horosa/models/gender.dart';
import 'package:horosa/widgets/forms/forms.dart';
import 'package:horosa/pages/pages.dart';
import 'package:horosa/widgets/non_chn_place_picker.dart';
import 'package:horosa/widgets/widgets.dart';
import 'widgets/date_of_birth.dart';
import 'widgets/gender.dart';

class BaZiFormPage extends StatefulWidget {
  static String route = '/bazi/form';

  const BaZiFormPage({super.key});

  @override
  State<BaZiFormPage> createState() => _BaZiFormPageState();
}

class _BaZiFormPageState extends State<BaZiFormPage> {
  final TextEditingController _controller = TextEditingController(text: '');
  Gender _gender = Gender.male; // 性别
  int _countryId = 45;
  String _countryName = '中国';
  String _timezone = '亚洲/北京';
  int _gmtOffset = 28800;
  Calendar? _birth;
  String _place = '默认地点 北京';
  DateOfBirthType _type = DateOfBirthType.time;
  bool? _useAST;
  double? _longitude;

  String _calculateAST(Calendar? birth) {
    if (birth == null || _longitude == null) {
      return '';
    }
    int year = birth.value.getYear();
    int month = birth.value.getMonth();
    int day = birth.value.getDay();
    int hour = birth.value.getHour();
    int minute = birth.value.getMinute();
    int second = birth.value.getSecond();
    DateTime dateTime = DateTime(year, month, day, hour, minute, second);
    double timeZoneOffset = _gmtOffset / 3600; // 北京时区偏移量

    ApparentSolarTime astCalculator =
        ApparentSolarTime(_longitude!, timeZoneOffset);
    DateTime ast = astCalculator.calculate(dateTime);
    int astYear = ast.year;
    String astMonth = ast.month.toString().padLeft(2, '0');
    String astDay = ast.day.toString().padLeft(2, '0');
    String astHour = ast.hour.toString().padLeft(2, '0');
    String astMinute = ast.minute.toString().padLeft(2, '0');
    return '$astYear-$astMonth-$astDay $astHour:$astMinute';
  }

  @override
  void initState() {
    super.initState();
    _longitude = 116.40752410888672;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffbfbfb),
        surfaceTintColor: const Color(0xfffbfbfb),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/arrow-left.svg',
            width: 17.w,
            height: 32.w,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          '八字排盘',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xff222426),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(36.w, 0, 36.w, 0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 12.w),
                width: 1.sw,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xffcdcdcd),
                      width: 1.w,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '姓       名：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '输入真实姓名',
                          hintStyle: TextStyle(
                            color: const Color(0x66393b41),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final res = await ProfileSvc.getRelationBook(size: 50);
                        if (!context.mounted) return;
                        if (res.statusCode == 200 && res.data['code'] == 0) {
                          if (res.data['data']['data'].isEmpty) {
                            toast('生辰库暂无数据~');
                            return;
                          }
                          List<Relation> relations =
                              (res.data['data']['data'] as List<dynamic>)
                                  .map((e) => Relation.fromJson(
                                      e as Map<String, dynamic>))
                                  .toList();
                          SinglePicker(
                            value: relations.first.id,
                            options: relations,
                            mapper: (option) =>
                                PickerItem(label: option.name, value: option.id),
                            onChange: (selectItem) {
                              if (!context.mounted) return;
                              setState(() {
                                _controller.text = selectItem.name;
                                _gender =
                                    Gender.getByAliasValue(selectItem.sex);
                                _birth = Calendar(
                                    type: CalendarType.solar,
                                    value: Solar.fromDate(DateTime.parse(
                                        selectItem.birthday)));
                                _place = CHNPlaceLoader.instance
                                    .getPlaceFromAdcode(CHNPlaceAdcode(
                                      province: selectItem.birthProvinceId,
                                      city: selectItem.birthCityId,
                                      county: selectItem.birthDistrictId,
                                    ))
                                    .toString();
                              });
                            },
                          ).show(context);
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/directory.svg',
                        width: 34.w,
                        height: 34.w,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 12.w),
                width: 1.sw,
                child: Row(
                  children: [
                    Text(
                      '性       别：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GenderRadioGroup(
                      value: _gender,
                      onChange: (val) {
                        setState(() {
                          _gender = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              DateOfBirth(
                value: _birth,
                onChange: (date) {
                  setState(() {
                    _birth = date;
                  });
                },
                onSwitchTab: (tab) {
                  setState(() {
                    _type = tab;
                  });
                },
              ),
              SizedBox(height: 30.w),
              Opacity(
                opacity: DateOfBirthType.pillars == _type ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: DateOfBirthType.pillars == _type,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30.w),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffcdcdcd),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '出生国家：',
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            CountryPicker(
                              value: _countryId,
                              onChange: (country) {
                                setState(() {
                                  _countryId = country.id;
                                  _timezone = country.defaultTimezone;
                                  _gmtOffset = country.timezones
                                      .firstWhere((timezone) =>
                                          timezone.zoneName == _timezone)
                                      .gmtOffset;
                                  _countryName = country.cnName;
                                  if (country.id == 45) {
                                    _place = '默认地点 北京';
                                    _longitude = 116.40752410888672;
                                  } else {
                                    _place = '未知地点';
                                    _longitude = country.longitude;
                                  }
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30.w),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffcdcdcd),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '时       区：',
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            TimeZonePicker(
                              countryId: _countryId,
                              value: _timezone,
                              onChange: (timezone) {
                                setState(() {
                                  _timezone = timezone.zoneName;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 30.w),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30.w),
                        width: 1.sw,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffcdcdcd),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '出生地点：',
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: () {
                                if (_countryId == 45) {
                                  PlacePicker(
                                    onChange: (place) {
                                      setState(() {
                                        _place =
                                            '${place?.city} ${place?.county}';
                                        _longitude = place?.lng;
                                      });
                                    },
                                  ).show(context);
                                } else {
                                  NonCHNPlacePicker(
                                    countryId: _countryId,
                                    onChange: (place) {
                                      setState(() {
                                        _place = '${place?.name}';
                                        _longitude = place?.longitude;
                                      });
                                    },
                                  ).show(context);
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    _place,
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow-down-fill.svg',
                                      width: 24.w,
                                      height: 24.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.w),
              Visibility(
                visible: DateOfBirthType.pillars != _type,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '是否使用真太阳时：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Visibility(
                      visible: _useAST ?? context.read<ConfigProvider>().useAST,
                      child: Expanded(
                        child: Text(
                          _calculateAST(_birth),
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    HorosaSwitch(
                      value: _useAST ?? context.read<ConfigProvider>().useAST,
                      onChange: (value) {
                        setState(() {
                          _useAST = value;
                        });
                      },
                    )
                  ],
                ),
              ),
              Visibility(
                visible: DateOfBirthType.pillars == _type && _birth != null,
                child: SizedBox(
                  width: 1.sw,
                  child: Text.rich(
                    textAlign: TextAlign.start,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '阳历：',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: '${_birth?.getSolarToStr()}\n',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '阴历：',
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: _birth?.getLunarToStr(),
                          style: TextStyle(
                            color: const Color(0xff222426),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 86.w,
              ),
              GestureDetector(
                onTap: () {
                  if (_birth?.value == null) {
                    toast('请选择您的出生时间', context: context);
                    return;
                  }
                  if (_birth?.value != null) {
                    BaZiInput input = BaZiInput(
                      username: _controller.text,
                      gender: _gender,
                      birthday: _birth!.value,
                      useAST: _useAST ?? false,
                      birthplace: BirthPlace(
                        country: _countryName,
                        place: _place,
                        timezone: _timezone,
                        gmtOffset: _gmtOffset,
                        longitude: _longitude ?? 116.40752410888672,
                      ),
                    );
                    ArchiveItem item = ArchiveItem(
                      id: 0,
                      extras: {},
                      input: input.toJson(),
                      output: {},
                      type: 1,
                      saveType: 1,
                    );
                    Navigator.of(context).pushNamed(
                      BaZiResultPage.route,
                      arguments: item,
                    );
                    () async {
                      try {
                        await ArchiveSvc.record(item);
                      } catch (_) {}
                    }();
                    LogSvc.logging(LogType.bazi);
                  }
                },
                child: Container(
                  height: 86.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '开始排盘',
                      style: TextStyle(
                        color: const Color(0xfff8cc76),
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.w,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
