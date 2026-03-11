import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/constants/profile.dart';
import 'package:horosa/models/calendar.dart';
import 'package:horosa/models/gender.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/services/profile.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/widgets/chn_place_picker.dart';
import 'package:horosa/widgets/forms/forms.dart';
import 'package:horosa/widgets/widgets.dart';
import 'package:lunar/lunar.dart';
import 'package:provider/provider.dart';
import 'package:horosa/providers/providers.dart';

enum EditUserInfoType {
  self(title: '个人信息'),
  create(title: '创建档案'),
  edit(title: '编辑档案');

  final String title;

  const EditUserInfoType({required this.title});
}

class EditUserInfoForm {
  final EditUserInfoType type;
  final dynamic payload;

  const EditUserInfoForm({
    required this.type,
    this.payload,
  });
}

class EditUserInfoPage extends StatefulWidget {
  static const String route = '/profile/edit-user-info';

  const EditUserInfoPage({super.key});

  @override
  State<EditUserInfoPage> createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  bool isInitialized = false;
  final TextEditingController _controller = TextEditingController(text: '');
  int _gender = Gender.male.aliasValue;
  Calendar? _birthday;
  String label = '亲人'; // 标签
  late CHNPlaceAdcode? _birthplace; // 出生地
  late CHNPlaceAdcode? _currentPlace; // 现居地
  EditUserInfoType type = EditUserInfoType.create;
  late dynamic userInfo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as EditUserInfoForm;
      type = args.type;
      if(type == EditUserInfoType.self) {
        userInfo = args.payload as UserInfo;
      } else if(type == EditUserInfoType.edit) {
        userInfo = args.payload as Relation;
      } else {
        userInfo = null;
      }
      if (!isInitialized) {
        setState(() {
          if (userInfo != null) {
            _controller.text = userInfo.name;
            _gender = userInfo.sex;
            _birthday = userInfo.birthday.isNotEmpty
                ? Calendar(
                    value: Solar.fromDate(DateTime.parse(userInfo.birthday)),
                    type: CalendarType.solar,
                  )
                : null;
            _birthplace = userInfo.birthProvinceId == 0
                ? null
                : CHNPlaceAdcode(
                    province: userInfo.birthProvinceId,
                    city: userInfo.birthCityId,
                    county: userInfo.birthDistrictId,
                  );
            _currentPlace = userInfo.residenceProvinceId == 0
                ? null
                : CHNPlaceAdcode(
                    province: userInfo.residenceProvinceId,
                    city: userInfo.residenceCityId,
                    county: userInfo.residenceDistrictId,
                  );
            if(type == EditUserInfoType.edit) {
              label = userInfo.relation ?? '亲人';
            }
          } else {
            _controller.text = '';
            _gender = Gender.male.aliasValue;
            _birthday = null;
            _birthplace = null;
            _currentPlace = null;
          }
          isInitialized = true;
        });
      }
      Log.i('TOKEN >>>> ${context.read<AuthProvider>().token}');
    });
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
          type.title,
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: isInitialized
        ? SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 28.w),
                  EditUserInfoType.self != type
                      ? const SizedBox()
                      : Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: ShapeDecoration(
                      color: const Color(0xffd7d7d7),
                      shape: const OvalBorder(
                        side: BorderSide.none,
                      ),
                      image: userInfo!.avatar.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(userInfo.avatar),
                        fit: BoxFit.contain,
                      )
                          : null,
                    ),
                  ),
                  SizedBox(height: 48.w),
                  Container(
                    padding: EdgeInsets.only(bottom: 30.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: const Color(0xffd7d7d7),
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '昵       称',
                          style: TextStyle(
                            color: const Color(0xff88898d),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(height: 30.w),
                            child: TextField(
                              controller: _controller,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                              decoration: InputDecoration(
                                hintText: '请输入昵称',
                                hintStyle: TextStyle(
                                  color: const Color(0xff88898d),
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),

                  /// 性别
                  Container(
                    padding: EdgeInsets.only(bottom: 30.w),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xffd7d7d7),
                            width: 1.w,
                          ),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '性       别',
                          style: TextStyle(
                            color: const Color(0xff88898d),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              HorosaRadio(
                                value: Gender.male.aliasValue,
                                label: Gender.male.label,
                                checked: Gender.male.aliasValue == _gender,
                                onChange: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                              ),
                              SizedBox(width: 46.w),
                              HorosaRadio(
                                value: Gender.female.aliasValue,
                                label: Gender.female.label,
                                checked: Gender.female.aliasValue == _gender,
                                onChange: (value) {
                                  setState(() {
                                    _gender = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),

                  /// 出生时间
                  Container(
                    padding: EdgeInsets.only(bottom: 30.w),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xffd7d7d7),
                            width: 1.w,
                          ),
                        )),
                    child: GestureDetector(
                      onTap: () {
                        DateTimePicker(
                          value: _birthday,
                          onChange: (datetime) {
                            setState(() {
                              _birthday = datetime;
                            });
                          },
                        ).show(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '出生时间',
                            style: TextStyle(
                              color: const Color(0xff88898d),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _birthday?.value.toYmdHms() ?? '未设置',
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Transform.scale(
                                  scaleX: -1,
                                  child: SvgPicture.asset(
                                    'assets/icons/arrow-left.svg',
                                    width: 16.w,
                                    height: 30.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.w),

                  /// 出生地址
                  Container(
                    padding: EdgeInsets.only(bottom: 30.w),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xffd7d7d7),
                            width: 1.w,
                          ),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '出生地址',
                          style: TextStyle(
                            color: const Color(0xff88898d),
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              PlacePicker(
                                value: _birthplace,
                                onChange: (place) {
                                  Log.i(place?.adcode);
                                  setState(() {
                                    _birthplace = place?.adcode;
                                  });
                                },
                              ).show(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _birthplace == null
                                      ? '未设置'
                                      : CHNPlace.fromAdcode(_birthplace!)
                                      .toString(),
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Transform.scale(
                                  scaleX: -1,
                                  child: SvgPicture.asset(
                                    'assets/icons/arrow-left.svg',
                                    width: 16.w,
                                    height: 30.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),

                  /// 现居住地
                  Container(
                    padding: EdgeInsets.only(bottom: 30.w),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xffd7d7d7),
                            width: 1.w,
                          ),
                        )),
                    child: GestureDetector(
                      onTap: () {
                        PlacePicker(
                          value: _currentPlace,
                          onChange: (place) {
                            Log.i(place?.adcode);
                            setState(() {
                              _currentPlace = place?.adcode;
                            });
                          },
                        ).show(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '现居住地',
                            style: TextStyle(
                              color: const Color(0xff88898d),
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _currentPlace == null
                                      ? '未设置'
                                      : CHNPlace.fromAdcode(_currentPlace)
                                      .toString(),
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Transform.scale(
                                  scaleX: -1,
                                  child: SvgPicture.asset(
                                    'assets/icons/arrow-left.svg',
                                    width: 16.w,
                                    height: 30.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.w),

                  /// 标签
                  Visibility(
                    visible: EditUserInfoType.self != type,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 30.w),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xffd7d7d7),
                              width: 1.w,
                            ),
                          )),
                      child: GestureDetector(
                        onTap: () {
                          SinglePicker(
                            value: label,
                            options: relationship
                                .map((r) => {'label': r, 'value': r})
                                .toList(),
                            onChange: (val) {
                              setState(() {
                                label = val['value']!;
                              });
                            },
                          ).show(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '标签',
                              style: TextStyle(
                                color: const Color(0xff88898d),
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    label,
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 24.w),
                                  Transform.scale(
                                    scaleX: -1,
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow-left.svg',
                                      width: 16.w,
                                      height: 30.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 48.w),
                  GestureDetector(
                    onTap: () async {
                      if (EditUserInfoType.self == type) {
                        UserInfo u = UserInfo(
                          id: userInfo!.id,
                          avatar: userInfo.avatar,
                          name: _controller.text,
                          sex: _gender,
                          birthday: _birthday!.value.toYmdHms(),
                          residenceProvinceId:
                          _currentPlace == null ? 0 : _currentPlace!.province,
                          residenceCityId:
                          _currentPlace == null ? 0 : _currentPlace!.city,
                          residenceDistrictId:
                          _currentPlace == null ? 0 : _currentPlace!.county,
                          birthProvinceId:
                          _birthplace == null ? 0 : _birthplace!.province,
                          birthCityId: _birthplace == null ? 0 : _birthplace!.city,
                          birthDistrictId:
                          _birthplace == null ? 0 : _birthplace!.county,
                        );
                        final res = await ProfileSvc.updateUserInfo(u);
                        if (!context.mounted) return;
                        if (res.statusCode == 200) {
                          if (res.data['code'] == 0) {
                            toast('保存成功！');
                            Provider.of<AuthProvider>(context, listen: false)
                                .setUserInfo(u);
                            Navigator.pop(context);
                          } else {
                            toast(res.data['msg']);
                          }
                        }

                        return;
                      }
                      if (EditUserInfoType.create == type || EditUserInfoType.edit == type) {
                        if(_controller.text.isEmpty) {
                          toast('昵称不能为空！');
                          return;
                        }
                        if(_birthday == null) {
                          toast('请选择出生时间！');
                          return;
                        }
                        if(_currentPlace == null) {
                          toast('请选择出生地址！');
                          return;
                        }
                        if(_currentPlace == null) {
                          toast('请选择现居住址！');
                          return;
                        }
                        Relation r = Relation(
                            name: _controller.text,
                            sex: _gender,
                            birthday: _birthday!.value.toYmdHms(),
                            relation: label,
                            residenceProvinceId:
                            _currentPlace == null ? 0 : _currentPlace!.province,
                            residenceCityId:
                            _currentPlace == null ? 0 : _currentPlace!.city,
                            residenceDistrictId:
                            _currentPlace == null ? 0 : _currentPlace!.county,
                            birthProvinceId:
                            _birthplace == null ? 0 : _birthplace!.province,
                            birthCityId:
                            _birthplace == null ? 0 : _birthplace!.city,
                            birthDistrictId:
                            _birthplace == null ? 0 : _birthplace!.county
                        );
                        if(EditUserInfoType.create == type) {
                          final res = await ProfileSvc.createRelation(r);
                          if (!context.mounted) return;
                          if (res.statusCode == 200) {
                            if (res.data['code'] == 0) {
                              toast('创建成功！');
                              Navigator.pop(context, { 'refresh': true });
                            } else {
                              toast(res.data['msg']);
                            }
                          }
                        } else {
                          r.id = userInfo.id;
                          final res = await ProfileSvc.updateRelation(r);
                          if (!context.mounted) return;
                          if (res.statusCode == 200) {
                            if (res.data['code'] == 0) {
                              toast('保存成功！');
                              Navigator.pop(context, { 'refresh': true });
                            } else {
                              toast(res.data['msg']);
                            }
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 86.w,
                      decoration: ShapeDecoration(
                        color: const Color(0xff222426),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(43.r),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          EditUserInfoType.create == type ? '创建' : '保存',
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
                  )
                ],
              ),
            ),
          )
        : const SizedBox.shrink(),
    );
  }
}
