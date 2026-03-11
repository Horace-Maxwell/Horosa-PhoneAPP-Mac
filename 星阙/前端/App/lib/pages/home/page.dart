import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/home_screen.dart';
import 'widgets/archive_screen.dart';
import 'widgets/profile_screen.dart';
import 'package:horosa/utils/config.dart';

const List<Widget> screens = [HomeScreen(), ArchiveScreen(), ProfileScreen()];

class HomePage extends StatefulWidget {
  static String route = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeIndex = 0;

  _handleChangeActiveIndex(index) {
    setState(() {
      _activeIndex = index;
    });
  }

  Future<void> initialization() async {
    await setFirstLaunch();
  }

  void showPrivacyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(left: 32.w, right: 32.w, top: 32.w),
          contentPadding: EdgeInsets.all(24.w),
          backgroundColor: const Color(0xff222426),
          // 背景颜色
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r), // 圆角
          ),
          title: Text(
            '用户隐私政策',
            // '个人信息保护指引',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'SourceHanSansCN',
              fontSize: 32.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              // child: RichText(
              //     softWrap: true,
              //     text: TextSpan(
              //     style: TextStyle(
              //       fontFamily: 'SourceHanSansCN',
              //       fontSize: 24.sp,
              //       color: Colors.white,
              //     ),
              //     children: [
              //       const TextSpan(text: '请您使用前充分阅读并理解'),
              //       TextSpan(
              //         text: '《用户协议》',
              //         style: const TextStyle(
              //             color: Color(0xfff8cc76),
              //             decoration: TextDecoration.underline,
              //             decorationColor: Color(0xfff8cc76)),
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             Navigator.of(context)
              //                 .pushNamed(TermsOfServicePage.route);
              //           },
              //       ),
              //       const TextSpan(text: '和'),
              //       TextSpan(
              //         text: '《隐私政策》',
              //         style: const TextStyle(
              //             color: Color(0xfff8cc76),
              //             decoration: TextDecoration.underline,
              //             decorationColor: Color(0xfff8cc76)),
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () {
              //             Navigator.of(context)
              //                 .pushNamed(PrivacyPolicyPage.route);
              //           },
              //       ),
              //       const TextSpan(text: '，需要使用的个人信息说明如下：\n\n'),
              //       const TextSpan(
              //           text:
              //               '1、存储空间：当您使用截图分享功能时我们需要申请存储权限，以通过写入本地缓存的方式存储应用的相关数据，以保证您的信息不会丢失，并降低流量消耗；\n'),
              //       const TextSpan(
              //           text:
              //               '2、位置信息：为了为用户提供实时位置查询服务。本应用需要获取您的位置权限，我们会请求您授权位置权限；\n'),
              //       const TextSpan(
              //           text:
              //               '3、您可以申请注销您的个人信息，在注销账户后，我们将停止为您提供产品或服务，并依据您的要求，删除您的个人信息；\n\n'),
              //       const TextSpan(
              //           text: '更多详细信息，请您阅读相关协议完整条款，您点击“同意”按钮代表您同意上述信息处理规则。'),
              //     ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '【星阙APP】隐私政策',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontFamily: 'SourceHanSansCN',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.w),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontFamily: 'SourceHanSansCN',
                      ),
                      children: [
                        TextSpan(
                          text: '\n欢迎您来到星阙APP！\n\n',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '星阙APP尊重并保护所有使用服务用户的个人隐私权，高度重视用户的隐私及个人信息的保护，本隐私政策帮助您了解我们收集哪些数据、为什么收集这些数据，会利用这些数据做些什么及如何保护这些数据。您在注册前务必认真阅读《隐私保护条例》（以下简称“协议”）及其条款的内容、充分理解各条款内容。\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '一旦您确认本用户注册协议后，本协议即在您和星阙APP之间产生法律效力，意味着您（即“用户”）完全同意并接受协议的全部条款。如果您对本协议任何条款有异议，您可选择不进入星阙APP。请您审慎阅读并选择接受或不接受协议（未成年人应在法定监护人陪同下阅读）。\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '一、处理个人信息的法律依据 \n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '我们将依据网络安全、隐私保护相关法律法规、业界成熟的安全标准收集和本协议的约定使用您的个人信息，除本隐私协议、法律法规、业界规则等另有规定外，在未征得您事先许可的情况下，星阙APP不会将这些信息对外披露或向第三方提供。 \n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '二、我们收集和使用您个人信息的范围 \n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        TextSpan(
                          text: '1.注册账号\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '您注册并登录星阙APP账号时至少向我们提供账号名称、手机号码，并创建密码。注册成功后，您提供的上述信息，将在您使用星阙APP平台和服务期间持续授权我们使用。在您注销账号时，我们将停止使用并删除上述信息或对您的个人信息进行匿名化处理，法律法规另有规定的除外。\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: '2.同时使用手机号码注册成功后，我们可能收集如下信息：\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text: '2.1 设备信息：',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '以便我们能在设备上为您提供服务，我们可能会将您的设备信息或电话号码与账号相关联，并收集设备属性信息、设备状态信息、设备链接信息。 \n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '2.2 展示和推送内容：',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '通过使用收集的信息，我们会向您提供搜索结果、个人化内容、用户研究分析与统计等服务。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '3.向您提供星阙APP产品和/或服务的附加业务功能\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '为了向您提供更优质的产品和服务，我们可能需要收集下述信息。如果您拒绝提供下述信息，不影响您正常使用本条2项所描述的星阙APP业务功能，但我们无法向您提供某些特定功能和服务。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '3.1 高德地图定位功能：',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              'GPS地址和位置信息，将用于更方便的计算星座信息；当您开启设备定位功能并使用星阙APP基于位置提供的相关服务时，我们会收集有关您的位置信息。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '4.我们可能从第三方间接获取您的个人信息\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '从第三方间接获取您的个人信息：您使用第三方账号登录星阙APP时，已授权星阙APP获得您的登记、公开的信息。您在该第三方平台上登记、公布、记录的公开信息（包括昵称、头像）。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '5.收集个人信息的范围及使用说明\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        WidgetSpan(
                          child: Table(
                            border: TableBorder.all(color: Colors.grey),
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    color: Colors.black12,
                                    child: Text(
                                      '类型',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    color: Colors.black12,
                                    child: Text(
                                      '数据项',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    color: Colors.black12,
                                    child: Text(
                                      '用途',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '登录信息',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '微信号、昵称、微信头像',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '用于与您沟通，基于您的同意后，用于您的系统登陆，以及后续的信息推送',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '个人信息',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '姓名、性别、地址',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '基于您的同意后，通过了解您对我们的关注点，以便为您提供更准确、恰当的信息或服务',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '高得地图定位',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '定位信息',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '基于您的同意后，将用于更方便的计算星座信息',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      'SN及设备信息',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '设备类型、设备名称或型号、操作系统类型及版本、屏幕分辨率',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '用于汇总分析产品的访问效果及统计数据，以便持续优化用户的使用体验',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '加速传感器',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '摇一摇',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: Text(
                                      '用于检测摇一摇功能，提供操作反馈，提高用户体验',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: '6.其他用途\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '我们会遵循正当、合法、必要的原则，出于本指引所述的以下目的，收集和使用您在使用服务过程中主动提供或因使用星阙APP产品和/或服务而产生的个人信息。如果我们要将您的个人信息用于本隐私条例未载明的其它用途，或基于特定目的将收集而来的信息用于其他目的，我们将以合理的方式向您告知，并在使用前再次征得您的同意。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '7.征得授权同意的例外\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '按照法律法规规定，下列如下情况我们将无法满足为您提供上述服务或功能，或者不征得您的授权同意的情况下收集、使用一些必要的个人信息：\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '7.1 与国家安全、国家利益相关的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '7.2 与公共安全、公共利益相关的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '7.3 与您或者第三方重大利益相关并可能会导致严重损害的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '7.4 与犯罪、司法程序、政府程序等直接相关的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '7.5 您存在主观恶意或滥用权利的（如您的请求将危害公共安全和其他人合法权益，或您的请求超出了一般技术手段和商业成本可覆盖的范围）；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '7.6涉及商业秘密的。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        TextSpan(
                          text: '三、我们如何共享、转让、公开披露您的个人信息 \n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        TextSpan(
                          text: '1.共享\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '我们会以高度的勤勉义务对待您的信息。除以下情形外，未经您同意，我们不会与星阙APP平台外的任何公司、组织和个人分享您的信息：在获得您的明确同意后，我们会与其他方共享您的个人信息。我们可能会根据法律法规规定，或按政府主管部门的强制性要求或司法裁定，对外共享您的个人信息。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '2.转让\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '我们不会将您的个人信息转让给除星阙APP及其关联公司外的任何公司、组织和个人，但以下情形除外：\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '2.1 事先获得您的明确授权或同意；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '2.2 满足法律法规、法律程序的要求或强制性的政府要求或司法裁定；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '2.3 如果我们或我们的关联公司涉及合并、分立、清算、资产或业务的收购或出售等交易，您的个人信息有可能作为此类交易的一部分而被转移，我们将确保该等信息在转移时的机密性，并要求新的持有您个人信息的公司、组织继续受此隐私政策的约束，否则我们将要求该公司、组织重新向您征求授权同意。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        TextSpan(
                          text: '3.公开披露\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text: '我们仅会在以下情形下，公开披露您的个人信息：\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '3.1 获得您的明确同意；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '3.2基于法律法规、法律程序、诉讼或政府主管部门强制性要求下。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        TextSpan(
                          text: '4.共享、转让、公开披露个人信息时事先征得授权同意的例外\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text: '在以下情形中，共享、转让、公开披露您的个人信息无需事先征得您的授权同意：\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.1 与国家安全、国防安全直接相关的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.2 与公共安全、公共卫生、重大公共利益直接相关的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.3 与犯罪侦查、起诉、审判和判决执行等直接相关的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.4 出于维护您或其他个人的生命、财产等重大合法权益但又很难得到本人同意的；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.5 您自行向社会公众公开的个人信息；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.6 从合法公开披露的信息中收集个人信息的，如合法的新闻报道、政府信息公开等渠道；\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text: '4.7法律法规规定的其他情形。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '根据法律规定，共享、转让经去标识化处理的个人信息，且确保数据接收方无法复原并重新识别个人信息主体的，不属于个人信息的对外共享、转让及公开披露行为，对此类数据的保存及处理将无需另行向您通知并征得您的同意。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '四、我们如何保护您的个人信息\n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '为防止您的信息丢失、未经您同意授权的访问、公开披露、泄露、转让等导致您个人信息的受损，星阙APP平台将采取一切合理、可靠、可行的方案与措施，保障您的个人信息安全。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '1.安全措施：\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '1.1 我们将以国家安全标准和法律法规的规定收集、使用、存储和传输用户信息，并通过用户协议和隐私政策告知您相关信息的使用目的和范围。同时，我们会对个人信息进行加密技术，以确保数据的保密性与安全性。 \n1.2 对员工信息接触者签署保密协议，定期进行安全能力与意识的培训。专岗专职，只有授权员工方可访问个人信息，若违反保密协议，将追究员工相关法律责任。\n1.3 严格选择合作伙伴，对其进行背景调查，与有知名度且信誉良好的企业合作；与合作伙伴信息接触者签署保密协议，约定泄密的违约责任，并仅提供必要合理的信息。\n1.4 成立安全团队，安全团队负责研发和应用安全技术和程序，以确保星阙APP平台及个人信息的安全。我们将对安全团队负责人和信息技术负责人进行背景调查，签署保密协议，约定泄密的法律责任，并持续对其进行安全能力与意识的培训。\n1.5 我们建立完善的信息安全管理制度和内部安全事件处置机制等。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '2.保存期限\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '您在使用星阙APP产品及服务期间，我们将持续为您保存您的个人信息。如果您将个人信息修改，我们会保存修改后的信息。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '3.安全事件通知\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '3.1我们会预先制定互联网安全事件预警方案，及时处置系统漏洞、计算机病毒、网络攻击、网络侵入等安全风险，在发生危害网络安全的事件时，我们会立即启动应急预案，采取相应的补救措施，并按照规定向有关主管部门报告。 \n3.2若发生个人信息安全事件，我们将通过您预留的个人信息（包含手机号码、电子邮箱等）及时通知您，并告知您案件进展和影响，我们将联合安全团队、法务部、技术部共同采取积极有效的处理手段，采取补救措施以降低风险。同时，我们将根据有关政府部门及法律法规要求，主动上报安全事件的情况，并可能采取法律手段解决安全事件。 \n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '五、您管理个人信息的权利 \n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '我们非常重视您对个人信息的关注，并尽全力保护您对于自己个人信息访问、更正以及撤回同意的权利，以使您拥有充分的能力保障您的隐私和安全。 您的权利包括：\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '1.访问和更正您的个人信息\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '除法律法规规定外，您有权随时访问和更正您的个人信息，具体包括：您可通过【我的】，访问或者修改您的邮箱信息、密码、用户名；\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '2.在以下情形中，您可以向我们提出删除个人信息的请求：\n',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '2.1 如果我们处理个人信息的行为违反法律法规；\n2.2 如果我们收集、使用您的个人信息，却未征得您的同意；\n2.3 如果我们处理个人信息的行为违反了与您的约定；\n2.4 如果您注销了星阙APP帐号；\n2.5 如果我们终止服务及运营。 \n以上删除请求一旦被响应，当您从我们的服务中删除信息后，我们可能不会立即从备份系统中删除相应的信息，但会在备份更新时删除这些信息。 \n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '六、未成年人个人信息\n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '若您是未成年人，建议您的监护人仔细阅读本隐私保护条例的条款，并在征得您的监护人同意的前提下使用我们的产品和服务或向我们提供信息。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '如您的监护人不同意您使用我们的服务或向我们提供信息，请您立即终止使用我们的服务并及时通知我们，以便我们采取相应的措施。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '如果监护人发现我们在未获监护人同意的情况下收集了未成年人的个人信息，请监护人反馈联系我们，我们在核准相关情况后尽快删除您的个人数据。\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '七、本隐私条例如何更新\n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '根据互联网的发展和有关法律、法规及规范性文件的变化，或者因业务发展需要，星阙APP有权对本协议的条款作出修改或变更，一旦本协议的内容发生变动，您可在星阙APP官方网站、APP查阅最新版协议条款，该公布行为视为星阙APP已经通知用户修改内容，而不另行对用户进行个别通知。在星阙APP修改协议条款后，如果您不接受修改后的条款，请立即停止使用星阙APP提供的服务，您继续使用星阙APP提供的服务将被视为接受修改后的协议。 \n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '八、如何联系我们\n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text: '如您对本隐私政策有任何意见或建议，可通过【我的-意见反馈】页面联系我们。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '为保障我们高效处理您的问题并及时向您反馈，需要您提交身份证明、有效联系方式和书面请求及相关证据，我们会在验证您的身份后处理您的请求。一般情况下，我们将在【五】天内回复。 \n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '九、开发者信息\n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text: '开发者名称:  灵明（杭州）文化有限公司\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '开发者地址:  浙江省杭州市余杭区仓前街道时尚万通城\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '电子邮件: lingmingwenhua@163.com\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text: '网址: http://daofajia.com/\n\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        TextSpan(
                          text: '十、法律适用、管辖与其他\n',
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                        const TextSpan(
                          text:
                              '1.本协议之订立、生效、解释、修订、补充、终止、执行与争议解决均适用中华人民共和国法律；如法律无相关规定的，参照商业惯例或行业惯例。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                        const TextSpan(
                          text:
                              '2.与本协议、使用星阙APP发生的任何争议或纠纷，双方应尽量友好协商解决；协商不成时，任何一方均有权将纠纷交由星阙APP所有人所在地人民法院管辖。\n',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontFamily: 'SourceHanSerifCN',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('不同意'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff8cc76), // 按钮颜色
                textStyle: const TextStyle(
                  fontFamily: 'SourceHanSerifCN',
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              onPressed: () async {
                await setFirstLaunch();
                if (!mounted) {
                  return;
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                '同意',
                style: TextStyle(color: Color(0xffffffff)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialization();
      // 获取传递过来的参数
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          _activeIndex = args['index'] ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_activeIndex],
      backgroundColor: const Color(0xfffbfbfb),
      bottomNavigationBar: BottomNavBar(
        current: _activeIndex,
        onChange: _handleChangeActiveIndex,
      ),
    );
  }
}
