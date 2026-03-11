import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horosa/models/user_info.dart';
import 'package:horosa/pages/pages.dart';
import 'package:horosa/pages/profile/birth_card.dart';
import 'package:horosa/services/profile.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/utils/toast.dart';

class BirthDataRepo extends StatefulWidget {
  static String route = '/profile/birth-data-repo';

  const BirthDataRepo({super.key});

  @override
  State<BirthDataRepo> createState() => _BirthDataRepoState();
}

class _BirthDataRepoState extends State<BirthDataRepo> {
  List<Relation> _data = [];
  // int _currentPage = 1;
  // int _total = 0;
  bool _isLoading = false;
  // bool _hasMore = true;
  final ScrollController _controller = ScrollController();

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    List<Relation> newData = [];

    ProfileSvc.getRelationBook(page: 1, size: 50).then((res) {
      if (res.statusCode == 200) {
        if (res.data['code'] == 0) {
          newData = (res.data['data']['data'] as List<dynamic>).map((e) {
            Log.d(e.runtimeType);
            return Relation.fromJson(e as Map<String, dynamic>);
          }).toList();
          setState(() {
            // _total = res.data['data']['total'];
            _data = newData;
          });
        } else {
          toast(res.data['msg']);
        }
      }
    }).catchError((error) {
      toast('Error: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          !_isLoading) {
        _loadData();
      }
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
          '生辰库',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/circle-add.svg',
              width: 36.w,
              height: 36.w,
            ),
            onPressed: () async {
               final result = await Navigator.pushNamed(context, EditUserInfoPage.route,
                  arguments: const EditUserInfoForm(
                    type: EditUserInfoType.create,
                    payload: null,
                  ));
              if (result != null && result is Map && result['refresh'] == true) {
                _loadData();
              }
            },
          )
        ],
      ),
      body: _data.isNotEmpty
          ? FutureBuilder(
              future: Future.value(_data),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SlidableAutoCloseBehavior(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _controller,
                            itemCount: _data.length,
                            itemBuilder: (context, index) {
                              return BirthCard(
                                data: _data[index],
                                onRefresh: _loadData,
                                onDelete: (id) {
                                  ProfileSvc.removeRelation(id).then((res) {
                                    if (res.statusCode == 200) {
                                      if (res.data['code'] == 0) {
                                        toast('删除成功');
                                        setState(() {
                                          _data.removeWhere(
                                              (element) => element.id == id);
                                        });
                                      } else {
                                        toast(res.data['msg']);
                                      }
                                    } else {
                                      toast('Error: ${res.statusCode}');
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : Column(
              children: [
                Image.asset('assets/images/no-content.png', width: 1.sw),
                Text(
                  '还没有内容哦~',
                  style: TextStyle(
                    color: const Color(0xff88898d),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10.w),
                Text(
                  '赶快去添加个生辰吧~',
                  style: TextStyle(
                    color: const Color(0xffcccccc),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
    );
  }
}
