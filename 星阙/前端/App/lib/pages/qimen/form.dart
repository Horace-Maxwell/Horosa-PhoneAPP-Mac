import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/models/calendar.dart';
import 'package:horosa/models/qi_men.dart';
import 'package:horosa/pages/pages.dart';
import 'package:horosa/providers/config.dart';
import 'package:horosa/services/log.dart';
import 'package:horosa/services/qi_men.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/widgets/non_chn_place_picker.dart';
import 'package:lunar/lunar.dart';
import 'package:provider/provider.dart';
import 'widgets/app_bar_title.dart';
import 'package:horosa/widgets/forms/forms.dart';
import 'package:horosa/widgets/widgets.dart';

class QiMenFormPage extends StatefulWidget {
  static String route = '/qimen/form';

  const QiMenFormPage({super.key});

  @override
  State<QiMenFormPage> createState() => _QiMenFormPageState();
}

class _QiMenFormPageState extends State<QiMenFormPage> {
  final TextEditingController _controller = TextEditingController(text: '');
  int _countryId = 45;
  String _timezone = '亚洲/北京';
  String _countryCNName = '中国';
  String _place = '默认地点 北京';
  double? _longitude = 116.40752410888672;
  late Calendar _ast;
  late Calendar _time;
  int _type = QiMenType.chaibu.value;

  Solar _calculateAST(Solar? solar) {
    if (solar == null || _longitude == null) {
      return Solar.fromDate(DateTime.now());
    }
    // 暂时停用真太阳时
    // int year = solar.getYear();
    // int month = solar.getMonth();
    // int day = solar.getDay();
    // int hour = solar.getHour();
    // int minute = solar.getMinute();
    // int second = solar.getSecond();
    // DateTime dateTime = DateTime(year, month, day, hour, minute, second);
    // double timeZoneOffset = _gmtOffset / 3600; // 北京时区偏移量
    //
    // ApparentSolarTime astCalculator =
    // ApparentSolarTime(_longitude!, timeZoneOffset);
    // DateTime ast = astCalculator.calculate(dateTime);
    // int astYear = ast.year;
    // int astMonth = ast.month;
    // int astDay = ast.day;
    // int astHour = ast.hour;
    // int astMinute = ast.minute;
    // int astSecond = ast.second;
    // return Solar.fromYmdHms(astYear, astMonth, astDay, astHour, astMinute, astSecond);
    return solar;
  }

  void _reset() {
    setState(() {
      _controller.text = '';
      _type = QiMenType.chaibu.value;
      _countryId = 45;
      _timezone = '亚洲/北京';
      _countryCNName = '中国';
      _place = '默认地点 北京';
      _longitude = 116.40752410888672;
      _time = Calendar(
          type: CalendarType.solar, value: Solar.fromDate(DateTime.now()));
      _ast =
          Calendar(type: CalendarType.solar, value: _calculateAST(_time.value));
    });
  }

  @override
  void initState() {
    super.initState();
    _type = context.read<ConfigProvider>().tuning.value;
    setState(() {
      _time = Calendar(
          type: CalendarType.solar, value: Solar.fromDate(DateTime.now()));
      _ast =
          Calendar(type: CalendarType.solar, value: _calculateAST(_time.value));
    });
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
        title: const QiMenAppBarTitle(),
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
                      '占       问：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '输入占问之事',
                          hintStyle: TextStyle(
                            color: const Color(0x66393b41),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
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
                      '国       家：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    CountryPicker(
                      value: _countryId,
                      onChange: (country) {
                        if (country.id == _countryId) {
                          return;
                        }
                        setState(() {
                          _countryId = country.id;
                          _timezone = country.defaultTimezone;
                          _countryCNName = country.cnName;
                          if (country.id == 45) {
                            _place = '默认地点 北京';
                            _longitude = 116.40752410888672;
                          } else {
                            _place = '未知地点';
                            _longitude = country.longitude;
                          }
                          _ast = Calendar(
                              type: CalendarType.solar,
                              value: _calculateAST(_time.value));
                        });
                      },
                    ),
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
                          _ast = Calendar(
                              type: CalendarType.solar,
                              value: _calculateAST(_time.value));
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
                      '地       区：',
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
                                _place = '${place?.city} ${place?.county}';
                                _longitude = place?.lng;
                                _ast = Calendar(
                                    type: CalendarType.solar,
                                    value: _calculateAST(_time.value));
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
                                _ast = Calendar(
                                    type: CalendarType.solar,
                                    value: _calculateAST(_time.value));
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
                      '时       间：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () {
                        DateTimePicker(
                          value: _ast,
                          onChange: (val) {
                            setState(() {
                              _time = val;
                              _ast = val;
                            });
                          },
                        ).show(context);
                      },
                      child: Text(
                        _ast.getSolarToStr(withChinese: true),
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                        ),
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
                    SizedBox(width: 20.w),
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
                      '定       局：',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Row(
                      children: [
                        HorosaRadio(
                          label: QiMenType.chaibu.label,
                          value: QiMenType.chaibu.value,
                          checked: QiMenType.chaibu.value == _type,
                          onChange: (val) {
                            setState(() {
                              _type = val;
                            });
                          },
                        ),
                        SizedBox(width: 78.w),
                        HorosaRadio(
                          label: QiMenType.zhirun.label,
                          value: QiMenType.zhirun.value,
                          checked: QiMenType.zhirun.value == _type,
                          onChange: (val) {
                            setState(() {
                              _type = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  QiMenInput input = QiMenInput(
                    guaType: _type,
                    question: _controller.text,
                    country: _countryCNName,
                    address: _place,
                    guaTime: QiMenGuaTime(
                      year: _ast.value.getYear(),
                      month: _ast.value.getMonth(),
                      day: _ast.value.getDay(),
                      hour: _ast.value.getHour(),
                      minute: _ast.value.getMinute(),
                    ),
                  );
                  try {
                    final res = await QiMenSvc.getQiMenResult(input);
                    if (!context.mounted) return;
                    if (res.statusCode == 200 && res.data['code'] == 0) {
                      Navigator.of(context).pushNamed(
                        QiMenResultPage.route,
                        arguments: ArchiveItem(
                          extras: {},
                          id: res.data['data']['record_id'] ?? 0,
                          input: input.toJson(),
                          output: res.data['data'],
                          type: 3,
                          saveType: 1,
                        ),
                      );
                      LogSvc.logging(LogType.qimen);
                      return;
                    }
                    toast(res.data['msg'] ?? '起卦失败，请稍后重试');
                  } catch (_) {
                    if (!context.mounted) return;
                    toast('起卦失败，请检查网络后重试');
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40.w),
                  height: 86.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(43),
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xff222426),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '立即起卦',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xfff8cc76),
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _reset,
                child: Container(
                  margin: EdgeInsets.only(top: 30.w),
                  height: 86.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2.w,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: const Color(0xff222426),
                      ),
                      borderRadius: BorderRadius.circular(45.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '重置',
                      style: TextStyle(
                        color: const Color(0xff222426),
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
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
