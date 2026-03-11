import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/constants/keys.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/providers/auth.dart';
import 'package:horosa/services/profile.dart';
import 'package:horosa/utils/local_mode.dart';
import 'package:horosa/utils/local_storage.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/toast.dart';
import 'package:horosa/pages/pages.dart';
import 'package:horosa/services/wechat.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static String route = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _wechatInstalled = true;
  bool _isRegister = false;
  bool _isAccount = false;
  bool _isWechat = true;
  bool _agree = false;
  Fluwx fluwx = Fluwx();
  String? from;
  LocalStorage localStorage = LocalStorage();

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  // 检测微信是否安装
  void checkWechatInstalled() async {
    bool installed = false;
    try {
      installed = await fluwx.isWeChatInstalled;
    } catch (_) {}
    // 如果是 IOS 需要检查微信是否安装
    if (Platform.isIOS) {
      setState(() {
        _wechatInstalled = installed;
        if (_wechatInstalled) {
          _isWechat = true;
        } else {
          _isAccount = true;
          _isWechat = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (LocalMode.enabled) {
      return;
    }
    checkWechatInstalled();
    fluwx.addSubscriber((response) async {
      if (response is WeChatAuthResponse) {
        final res = await WechatSvc.getAccessToken(response.code!);
        if (!mounted) return;
        if (res.statusCode == 200 && res.data['code'] == 0) {
          String token = res.data['data']['token'];
          context.read<AuthProvider>().setToken(token);
          await localStorage.write(AppKeys.accessToken, token);
          final userRes = await ProfileSvc.getUserInfo();
          if (!mounted) return;
          context.read<AuthProvider>().setUserInfo(
              UserInfo.fromJson(userRes.data['data'] as Map<String, dynamic>));
          Navigator.pushReplacementNamed(context, HomePage.route,
              arguments: token);
        }
        if (!mounted) return;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 60.w, top: 229.w, right: 60.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 153.w,
                  height: 153.w,
                  decoration: ShapeDecoration(
                    color: const Color(0xff222426),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(77),
                    ),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/icons/logo.svg',
                    width: 98.w,
                    height: 98.w,
                  )),
                ),
                Visibility(
                  visible: _wechatInstalled && _isWechat,
                  child: GestureDetector(
                    onTap: () async {
                      if (!_agree) {
                        toast(context: context, '请阅读并勾选相关协议');
                        return;
                      }
                      fluwx
                          .authBy(which: NormalAuth(scope: 'snsapi_userinfo'))
                          .then((data) {});
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 240.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40.w, vertical: 18.w),
                          decoration: ShapeDecoration(
                            color: const Color(0xff222426),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(43),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/wechat.svg',
                                    width: 43.w,
                                    height: 36.w,
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    '微信一键登录',
                                    style: TextStyle(
                                      color: const Color(0xfff8cc76),
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 24.w, left: 16.w, right: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isRegister = true;
                                    _isWechat = false;
                                    _isAccount = false;
                                  });
                                },
                                child: Text(
                                  '注册',
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 24.sp,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isAccount = true;
                                    _isWechat = false;
                                    _isRegister = false;
                                  });
                                },
                                child: Text(
                                  '账号登录',
                                  style: TextStyle(
                                    color: const Color(0xff222426),
                                    fontSize: 24.sp,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isRegister,
                  child: Padding(
                    padding: EdgeInsets.only(top: 64.w),
                    child: SizedBox(
                      width: 1.sw - 64.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '账       号：',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextField(
                                  controller: _accountController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请输入账号',
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
                          Divider(height: 1.h, thickness: 1.h),
                          Row(
                            children: [
                              Text(
                                '密       码：',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请输入密码',
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
                          Divider(height: 1.h, thickness: 1.h),
                          Row(
                            children: [
                              Text(
                                '确认密码：',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextField(
                                  controller: _passwordConfirmController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请再次输入密码',
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
                          Divider(height: 1.h, thickness: 1.h),
                          GestureDetector(
                            onTap: () async {
                              if (!_agree) {
                                toast(context: context, '请阅读并勾选相关协议');
                                return;
                              }
                              if (_accountController.text.isEmpty) {
                                toast(context: context, '请输入账号');
                                return;
                              }
                              // 判断账号格式是否正确：长度 6 ~ 20，只能包含字母 + 数字
                              if (!RegExp(r'^[a-zA-Z0-9]{6,20}$')
                                  .hasMatch(_accountController.text)) {
                                toast(
                                    context: context, '账号格式为字母 + 数字，长度6 ~ 20');
                                return;
                              }

                              if (_passwordController.text.isEmpty) {
                                toast(context: context, '请输入密码');
                                return;
                              }
                              // 判断密码格式是否正确：最低8位密码，且为英文+数字的组合
                              if (!RegExp(r'^[a-zA-Z0-9]{8,}$')
                                  .hasMatch(_passwordController.text)) {
                                toast(context: context, '密码格式为英文 + 数字，最少8位');
                                return;
                              }
                              if (_passwordController.text !=
                                  _passwordConfirmController.text) {
                                toast(context: context, '两次密码输入不一致');
                                return;
                              }

                              final res = await ProfileSvc.register(
                                  _accountController.text,
                                  _passwordController.text,
                                  _passwordConfirmController.text);
                              if (!context.mounted) return;
                              if (res.statusCode == 200) {
                                Log.d(res.data);
                                if (res.data['code'] == 0) {
                                  toast(context: context, '注册成功');
                                  setState(() {
                                    _isAccount = true;
                                    _isWechat = false;
                                    _isRegister = false;
                                    _passwordController.text = '';
                                    _passwordConfirmController.text = '';
                                  });
                                } else {
                                  toast(context: context, res.data['msg']);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 64.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 18.w),
                              decoration: ShapeDecoration(
                                color: const Color(0xff222426),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(43),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '注        册',
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: 24.w, left: 16.w, right: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isAccount = true;
                                      _isWechat = false;
                                      _isRegister = false;
                                    });
                                  },
                                  child: Text(
                                    '去登录',
                                    style: TextStyle(
                                      color: const Color(0xff222426),
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _wechatInstalled,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isWechat = true;
                                        _isRegister = false;
                                        _isAccount = false;
                                      });
                                    },
                                    child: Text(
                                      '微信登录',
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isAccount,
                  child: Padding(
                    padding: EdgeInsets.only(top: 64.w),
                    child: SizedBox(
                      width: 1.sw - 64.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '账       号：',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextField(
                                  controller: _accountController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请输入账号',
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
                          Divider(height: 1.h, thickness: 1.h),
                          Row(
                            children: [
                              Text(
                                '密       码：',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请输入密码',
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
                          Divider(height: 1.h, thickness: 1.h),
                          GestureDetector(
                            onTap: () async {
                              if (!_agree) {
                                toast(context: context, '请阅读并勾选相关协议');
                                return;
                              }
                              if (_accountController.text.isEmpty) {
                                toast(context: context, '请输入账号');
                                return;
                              }

                              if (_passwordController.text.isEmpty) {
                                toast(context: context, '请输入密码');
                                return;
                              }

                              final res = await ProfileSvc.login(
                                  _accountController.text,
                                  _passwordController.text);
                              if (!context.mounted) return;
                              if (res.statusCode == 200) {
                                Log.d(res.data);
                                if (res.data['code'] == 0) {
                                  String token = res.data['data']['token'];
                                  context.read<AuthProvider>().setToken(token);
                                  await localStorage.write(
                                      AppKeys.accessToken, token);
                                  final userRes = await ProfileSvc.getUserInfo();
                                  if (!context.mounted) return;
                                  context.read<AuthProvider>().setUserInfo(
                                      UserInfo.fromJson(userRes.data['data']
                                          as Map<String, dynamic>));
                                  Navigator.pushReplacementNamed(
                                      context, HomePage.route,
                                      arguments: token);
                                } else {
                                  toast(context: context, res.data['msg']);
                                }
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 64.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 18.w),
                              decoration: ShapeDecoration(
                                color: const Color(0xff222426),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(43),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '登        录',
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
                          Visibility(
                            visible: _wechatInstalled,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 24.w, left: 16.w, right: 16.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isRegister = true;
                                        _isWechat = false;
                                        _isAccount = false;
                                      });
                                    },
                                    child: Text(
                                      '注册',
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isWechat = true;
                                        _isRegister = false;
                                        _isAccount = false;
                                      });
                                    },
                                    child: Text(
                                      '微信登录',
                                      style: TextStyle(
                                        color: const Color(0xff222426),
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 55.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 64.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agree = !_agree;
                            });
                          },
                          child: Container(
                            width: 26.w,
                            height: 26.w,
                            decoration: ShapeDecoration(
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 2.w,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: const Color(0xff333333),
                                ),
                              ),
                              color: _agree
                                  ? const Color(0xff222426)
                                  : const Color(0xffffffff),
                            ),
                            child: _agree
                                ? Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/tick.svg',
                                      width: 10.w,
                                      height: 12.w,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _agree = !_agree;
                                });
                              },
                            text: '我已阅读并同意',
                            style: TextStyle(
                              color: const Color(0xff222426),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: '《星阙软件许可及用户协议》',
                                style: TextStyle(
                                  color: const Color(0xff418ffb),
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle the tap on the first link
                                    Navigator.of(context)
                                        .pushNamed(TermsOfServicePage.route);
                                  },
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      _agree = !_agree;
                                    });
                                  },
                                text: '及星阙',
                                style: TextStyle(
                                  color: const Color(0xff222426),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '《隐私政策》',
                                style: TextStyle(
                                  color: const Color(0xff418ffb),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle the tap on the second link
                                    Navigator.of(context)
                                        .pushNamed(PrivacyPolicyPage.route);
                                  },
                              ),
                            ],
                          ),
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
    );
  }
}
