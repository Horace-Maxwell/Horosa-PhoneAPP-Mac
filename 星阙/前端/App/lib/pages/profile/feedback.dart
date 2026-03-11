// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/services/feedback.dart';
import 'package:horosa/utils/toast.dart';
// import 'package:image_picker/image_picker.dart';

class FeedbackPage extends StatefulWidget {
  static String route = '/profile/feedback';

  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _controller = TextEditingController();
  // File? _imageFile;
  //
  // void _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _imageFile = File(pickedFile!.path);
  //   });
  // }

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
          '意见反馈',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片上传
            // GestureDetector(
            //   onTap: _pickImage,
            //   child: Container(
            //     width: 153.w,
            //     height: 153.w,
            //     decoration: ShapeDecoration(
            //       color: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(25.r),
            //       ),
            //       shadows: [
            //         BoxShadow(
            //           color: const Color(0x13222327),
            //           blurRadius: 12.r,
            //           offset: Offset(0, 8.w),
            //           spreadRadius: -4.r,
            //         )
            //       ],
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         SvgPicture.asset('assets/icons/add.svg', width: 16.w, height: 16.w,),
            //         SizedBox(height: 10.w),
            //         Text(
            //           '添加照片',
            //           style: TextStyle(
            //             color: const Color(0xff222426),
            //             fontSize: 24.sp,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 30.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 30.w),
              height: 300.w,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36.r),
                ),
              ),
              child: TextField(
                controller: _controller,
                // keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 7,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: '如果您对星阙有什么问题，请留言！！！我们会积极改进～',
                  hintStyle: TextStyle(
                    color: const Color(0xff88898d),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(36.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 48.w),
            GestureDetector(
              onTap: () async {
                final res = await FeedbackSvc.feedback(_controller.text);
                if (!context.mounted) return;
                if(res.statusCode == 200) {
                  if(res.data['code'] == 0) {
                    toast('提交成功！');
                    Navigator.pop(context);
                  } else {
                    toast(res.data['msg']);
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
                    '提交',
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
      )),
    );
  }
}
