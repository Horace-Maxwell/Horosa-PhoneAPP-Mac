import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermsOfServicePage extends StatelessWidget {
  static String route = '/terms-of-service';

  const TermsOfServicePage({super.key});

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
          '用户协议',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(left: 36.w, top: 18.w, right: 36.w, bottom: 36.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '【星阙APP】用户协议',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff222426),
                  fontSize: 36.sp,
                  fontFamily: 'SourceHanSansCN',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12.w),
              SizedBox(height: 12.w),
              RichText(
                softWrap: true,
                text: TextSpan(
                  style: TextStyle(
                    color: const Color(0xff222426),
                    fontSize: 24.sp,
                    fontFamily: 'SourceHanSansCN',
                  ),
                  children: [
                    const TextSpan(
                      text:
                          '本协议是您与星阙APP客户端（简称“本客户端”，包括星阙APP、公众号、小程序等）所有者（以下简称为“星阙APP”）之间就星阙APP客户端服务等相关事宜所订立的契约，请您仔细阅读本注册协议，您完成信息填写并点选“同意”后，本协议即构成对双方有约束力的法律文件。 \n\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第1条 本客户端服务条款的确认和接纳\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '1.1 本客户端的各项电子服务的所有权和经营权归星阙APP所有。用户同意所有注册协议条款并完成注册程序，才能成为本客户端的正式用户。用户确认：本协议条款是处理双方权利义务的契约，始终有效，法律另有强制性规定或双方另有特别约定的，依其规定。 \n1.2 用户点选同意本协议的，即视为用户确认自己具有享受本客户端服务的相应的权利能力和行为能力，能够独立承担法律责任。如用户通过第三方帐户（微信）创建、绑定或登录星阙APP账户的，我们会从第三方获取您授权共享的第三方帐户信息（如头像、昵称等），并将该第三方帐户信息作为星阙APP的帐户信息。\n在您注册星阙APP账号时，收集您的手机号码是为了满足相应法律法规的网络实名制要求，请您谨慎考虑后提供。若您不提供这类信息，您可能无法成功注册星阙APP账号或使用服务时将受限。\n1.3 如果您在18周岁以下，您只能在父母或监护人的监护参与下才能使用本客户端。或非完全民事行为能力人，也只能在监护人参与下才能使用本客户端。\n1.4 星阙APP保留在中华人民共和国大陆地区法施行之法律允许的范围内独自决定拒绝服务、关闭用户账户、清除或编辑内容或取消订单的权利。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第2条 本客户端服务\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '2.1 星阙APP通过互联网依法为用户提供互联网信息等服务，用户在完全同意本协议及本客户端相关其他规定的情况下，方有权使用本客户端的相关服务。 \n2.2 用户必须自行准备如下设备和承担如下开支：\n（1）上网设备，包括并不限于电脑或者其他上网终端、调制解调器及其他必备的上网装置；\n（2）上网开支，包括并不限于网络接入费、上网设备租用费、手机流量费等。 \n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第3条 用户信息\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '3.1 用户应自行诚信向本客户端提供注册资料，用户同意其提供的注册资料真实、准确、完整、合法有效，用户注册资料如有变动的，应及时更新其注册资料。如果用户提供的注册资料不合法、不真实、不准确、不详尽的，用户需承担因此引起的相应责任及后果，并且星阙APP保留终止用户使用星阙APP各项服务的权利。 \n3.2 用户注册成功后，将产生用户名、号码等账户信息，用户应谨慎合理的保存、使用其用户名在内的账户信息。用户若发现任何非法使用用户账号或存在安全漏洞的情况，请立即通知本客户端并向公安机关报案。\n3.3 用户同意，星阙APP拥有通过站内信、邮件、短信电话等合法合理的形式，向在本客户端注册用户发送新功能上线、功能更新、举办活动等告知信息的权利；如您不同意接收此信息的，请告知星阙APP，星阙APP将不再向您发送如上信息。\n3.4 用户不得将在本站注册获得的账户借给他人使用，否则用户应承担由此产生的全部责任，并与实际使用人承担连带责任。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第4条 用户依法言行义务\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '本协议依据国家相关法律法规规章制定，用户同意严格遵守以下义务：\n（1）不得传输或发表：煽动抗拒、破坏宪法和法律、行政法规实施的言论，煽动颠覆国家政权，推翻社会主义制度的言论，煽动分裂国家、破坏国家统一的的言论，煽动民族仇恨、民族歧视、破坏民族团结的言论；\n（2）从中国大陆向境外传输资料信息时必须符合中国有关法规；\n（3）不得利用本客户端从事洗钱、窃取商业秘密、窃取个人信息等违法犯罪活动；\n（4）不得干扰本客户端的正常运转，不得侵入本客户端及国家计算机信息系统；\n（5）不得传输或发表任何违法犯罪的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的、淫秽的、不文明的等信息资料；\n（6）不得传输或发表损害国家社会公共利益和涉及国家安全的信息资料或言论；\n（7）不得教唆他人从事本条所禁止的行为；\n（8）不得利用在本客户端注册的账户进行牟利性经营活动；\n（9）不得发布任何侵犯他人著作权、商标权等知识产权或合法权利的内容；用户应关注并遵守本客户端不时公布或修改的各类合法规则规定。本客户端保有删除各类不符合法律政策或不真实的信息内容而无须通知用户的权利。若用户未遵守以上规定的，本客户端有权作出独立判断并采取暂停或关闭用户帐号等措施。用户须对自己在网上的言论和行为承担法律责任。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第5条 服务信息展示\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '5.1本客户端上的服务/服务价格、数量、能否提供等信息随时都有可能发生变动，本客户端不作特别通知。本客户端显示的信息可能会有一定的滞后性或差错，对此情形您知悉并理解；星阙APP欢迎纠错，并会视情况给予纠错者一定的奖励。为表述便利，产品和服务简称为“产品”或“服务”。\n5.2 为了更好的为您提供服务，星阙APP保证提供安全、稳定的服务场所，保证服务的顺利进行。一旦发现您提供的个人 信息中有虚假，星阙APP有权立即终止向用户提供的所有服务，并冻结用户的帐户，有权要求用户赔偿因提供虚假信息给星阙APP及第三方造成的损失。\n5.3星阙APP有权对用户的注册数据及咨询的行为进行查阅，发现注册数据或咨询行为中存在任何问题或怀疑，均有权向用户发出询问及要求改正的通知或者直接作出删除等处理。\n5.4系统因下列状况无法正常运作，使用户无法使用服务时，星阙APP不承担损害赔偿责任，该状况包括但不限于：\n（1）星阙APP在本网站公告之系统停机维护期间。\n（2）电信设备出现故障不能进行数据传输的。\n（3）因台风、地震、海啸、洪水、停电、战争、恐怖袭击等不可抗力之因素，造成系统障碍不能执行业务的。\n（4）由于黑客攻击、电信部门技术调整或故障、银行方面的问题等原因而造成的服务中断或者延迟。\n5.5 星阙APP提供的服务中可能包含广告，用户同意在使用过程中显示星阙APP和第三方供应商、合作伙伴提供的广告。用户因就第三方提供的服务、产品与第三方产生争议的，由用户与第三方自行解决，与星阙APP无关，但星阙APP会给予您积极的配合与协助。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第6条 知识产权\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '6.1 本软件是由星阙APP开发，星阙APP的一切知识产权，以及与软件相关的所有信息内容，包括但不限于：文字表述及其组合、图标、图饰、图像、图表、色彩、界面设计、版面框架、有关数据、附加程序、印刷材料或电子文档、代码等均归星阙APP所有，受中华人民共和国著作权法和国际著作权条约以及其他知识产权法律法规的保护。\n6.2未经星阙APP书面同意，用户不得为任何营利性或非营利性的目的自行实施、利用、转让或许可任何三方实施、利用、转让上述知识产权。出现上述未经许可之行为时，星阙APP保留追究相关责任人法律责任之权利。\n6.3 在星阙APP上传或发表的内容，用户应保证其为著作权人或已取得合法授权，并且该内容不会侵犯任何第三方的合法权益。如果第三方提出关于著作权的异议，星阙APP有权根据实际情况删除相关的内容，且有权追究用户的法律责任。给星阙APP或任何第三方造成损失的，用户应负责全额赔偿。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第7条 个人隐私\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '星阙APP视保护用户隐私为最重要、最基本义务，星阙APP保证遵守法律法规，严格遵循保护用户隐私原则，为用户提供安全、可靠的服务。星阙APP保证不对外公开或向无关的第三方提供用户资料信息，但下列情形除外：\n1.事先获得用户的明确授权；\n2.根据国家有关的法律法规要求或者相关政府主管部门的要求；\n3.为维护社会公众的利益。\n您使用或继续使用我们的服务，即意味着同意我们按照星阙APP《隐私保护条例》收集、使用、储存和分享您的相关信息。具体条款请参见星阙APP《隐私保护条例》。 \n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第8条 责任限制及不承诺担保\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '8.1 除非另有明确的书面说明，本客户端及其所包含的或以其它方式通过本客户端提供给您的全部信息、内容、材料、产品（包括软件）和服务，均是在“按现状”和“按现有”的基础上提供的。除非另有明确的书面说明，星阙APP不对本客户端的运营及其包含在本客户端上的信息、内容、材料、产品（包括软件）或服务作任何形式的、明示或默示的声明或担保（根据中华人民共和国法律另有规定的以外）。\n8.2 星阙APP不担保本客户端所包含的或以其它方式通过本客户端提供给您的全部信息、内容、材料、产品（包括软件）和服务、其服务器或从本客户端发出的电子信件、信息没有病毒或其他有害成分。如因不可抗力或其它本站无法控制的原因使本客户端销售系统崩溃或无法正常使用导致网上交易无法完成或丢失有关的信息、记录等，星阙APP会合理地尽力协助处理善后事宜。\n8.3星阙APP所承载的内容（文、图、视频、音频）均为传播国学文化资讯目的，不对其真实性、科学性、严肃性做任何形式保证。星阙APP 客户端所有信息仅供参考。',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '同时，用户须为自己注册账号下的行为负责，包括用户所导入、上载、传送的任何内容以及由此产生的任何后果；用户应对星阙APP客户端中的内容自行加以判断，并承担因使用内容而引起的所有风险。\n',
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                      '8.4星阙APP致力于提供正确、完整的咨询资讯，但不保证信息的准确性、正确性和完整性，且不对因信息的不正确或遗漏导致的任何损失或损害承担责任。\n8.5 星阙APP所提供的任何建议报告，仅供参考，不能替代医生、医务人员等专业人员的建议，如自行使用星阙APP中咨迅、建议等资料发生偏差，星阙APP概不负责，亦不负任何法律责任。\n星阙APP保留对本声明作出不定时修改的权利。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第9条 协议更新及用户关注义务\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '根据国家法律法规变化及网络运营需要，星阙APP有权对本协议条款不时地进行修改，修改后的协议一旦被张贴在本客户端上即生效，并代替原来的协议。用户可随时登陆查阅最新协议；用户有义务不时关注并阅读最新版的协议及客户端公告。如用户不同意更新后的协议，可以且应立即停止接受星阙APP客户端依据本协议提供的服务；如用户继续使用本客户端提供的服务，即视为同意更新后的协议。星阙APP建议您在使用本客户端之前阅读本协议及本客户端的公告。如果本协议中任何一条被视为废止、无效或因任何理由不可执行，该条应视为可分的且并不影响任何其余条款的有效性和可执行性。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第10条 法律管辖和适用\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '本协议的订立、执行和解释及争议的解决均应适用在中华人民共和国大陆地区适用之有效法律（但不包括其冲突法规则）。如发生本协议与适用之法律相抵触时，则这些条款将完全按法律规定重新解释，而其它有效条款继续有效。如缔约方就本协议内容或其执行发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均可向有管辖权的中华人民共和国大陆地区法院提起诉讼。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第11条 其他\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '11.1星阙APP客户端所有者是指在政府部门依法许可或备案的星阙APP经营主体。\n11.2 星阙APP尊重用户和消费者的合法权利，本协议及本客户端上发布的各类规则、声明等其他内容，均是为了更好的、更加便利的为用户和消费者提供服务。本客户端欢迎用户和社会各界提出意见和建议，星阙APP将虚心接受并适时修改本协议及本客户端的各类规则。\n11.3 您点选本协议上方的“我同意星阙APP的《用户协议》”按钮即视为您完全接受本协议，在点击之前请您再次确认已知悉并完全理解本协议的全部内容。\n\n',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '第12条 如何联系本应用\n',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        height: 2,
                      ),
                    ),
                    TextSpan(
                      text:
                      '如果您对本隐私政策有任何疑问、意见或建议，通过以下方式与本应用联系：\n应用名称：星阙\n企业名称：灵明（杭州）文化有限公司\n个人信息保护联系方式：lingmingwenhua@163.com\n在线客服：我的-意见反馈，通常情况下，本应用将在【五】天内回复您。',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
