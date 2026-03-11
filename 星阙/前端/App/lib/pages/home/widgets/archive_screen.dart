import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:horosa/models/archive.dart';
import 'package:horosa/pages/login/page.dart';
import 'package:horosa/providers/auth.dart';
import 'package:horosa/utils/log.dart';
import 'package:horosa/pages/home/widgets/liuren_archive.dart';
import 'package:horosa/pages/home/widgets/liuyao_archive.dart';
import 'package:horosa/pages/home/widgets/qimen_archive.dart';
import 'package:horosa/services/archive.dart';
import 'package:horosa/utils/toast.dart';
import 'package:provider/provider.dart';

import 'bazi_archive.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  bool _loading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _pageSize = 10; // 每页的数据量
  final ScrollController _controller = ScrollController();
  final List<ArchiveItem> _archives = [];

  @override
  void initState() {
    super.initState();
    _loadMoreData(); // 初始加载数据

    // 监听滚动事件，加载更多数据
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent &&
          !_loading &&
          _hasMore) {
        _loadMoreData(); // 到达底部加载更多数据
      }
    });
  }

  // 获取档案数据
  Future<void> _loadMoreData() async {
    if (_loading) return; // 防止重复加载
    setState(() {
      _loading = true;
    });

    try {
      final response =
          await ArchiveSvc.getArchiveList(page: _page, size: _pageSize);
      if (response.statusCode == 200 && response.data['code'] == 0) {
        List<ArchiveItem> newItems = (response.data['data']['data'] as List)
            .map((item) => ArchiveItem.fromJson(item))
            .toList();

        setState(() {
          _archives.addAll(newItems);
          _loading = false;
          _page++;
          if (newItems.length < _pageSize) {
            _hasMore = false; // 没有更多数据
          }
        });
      }
    } catch (e) {
      Log.e('Error loading data: $e');
      setState(() {
        _loading = false;
        _hasMore = false;
      });
    }
  }

  // 下拉刷新
  Future<void> _refreshData() async {
    setState(() {
      _page = 1;
      _archives.clear();
      _hasMore = true;
    });
    await _loadMoreData();
  }

  // 删除档案
  void _removeItem(int id, int index) async {
    try {
      final response = await ArchiveSvc.removeArchive(id);
      if (response.statusCode == 200 && response.data['code'] == 0) {
        setState(() {
          _archives.removeAt(index);
        });
        toast('删除成功~');
      } else {
        toast(response.data['msg']);
      }
    } catch (e) {
      Log.e('Error deleting item: $e');
      toast('删除失败，请稍后重试');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = context.read<AuthProvider>().isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffbfbfb),
        centerTitle: true,
        title: Text(
          '档案',
          style: TextStyle(
            color: const Color(0xff222426),
            fontSize: 36.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: isLoggedIn
          ? _loading || _archives.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.w),
                  child: SlidableAutoCloseBehavior(
                    child: _loading && _archives.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator()) // 初始加载时显示加载指示器
                        : RefreshIndicator(
                            onRefresh: _refreshData,
                            child: ListView.builder(
                              controller: _controller,
                              itemCount: _archives.length + 1, // 加载更多指示器
                              itemBuilder: (context, index) {
                                if (index == _archives.length) {
                                  return _hasMore
                                      ? _loading
                                          ? Padding(
                                              padding: EdgeInsets.all(16.w),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                      : Center(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 16.w),
                                            child: Text(
                                              '我也是有底线的~',
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff88898d),
                                              ),
                                            ),
                                          ),
                                        );
                                }

                                final item = _archives[index];
                                return ArchiveCard(
                                  id: item.id,
                                  type: ArchiveType.getArchiveTypeByValue(
                                      item.type),
                                  data: item,
                                  onDelete: () => _removeItem(item.id, index),
                                );
                              },
                            ),
                          ),
                  ),
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
                      '随便去逛逛，了解更多有趣的事吧~',
                      style: TextStyle(
                        color: const Color(0xffcccccc),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                )
          : _buildLoginPrompt(context),
    );
  }

  // 构建未登录时的提示
  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/no-login.png', width: 1.sw),
        SizedBox(height: 58.w),
        Text(
          '登录后才能查看消息哦~',
          style: TextStyle(
            color: const Color(0xff88898d),
            fontSize: 30.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 48.w),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(LoginPage.route);
          },
          child: Container(
            width: 302.w,
            height: 86.w,
            decoration: ShapeDecoration(
              color: const Color(0xff222426),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(43.r),
              ),
            ),
            child: Center(
              child: Text(
                '登录/注册',
                textAlign: TextAlign.center,
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
    );
  }
}

class ArchiveCard extends StatefulWidget {
  const ArchiveCard({
    super.key,
    required this.id,
    required this.type,
    required this.data,
    required this.onDelete,
  });

  final ArchiveItem data;
  final int id;
  final ArchiveType type;
  final VoidCallback onDelete;

  @override
  State<ArchiveCard> createState() => _ArchiveCardState();
}

class _ArchiveCardState extends State<ArchiveCard>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: Slidable(
        key: ValueKey(widget.id),
        controller: controller,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 158.w / (1.sw - 72.w),
          children: [
            GestureDetector(
              onTap: () {
                widget.onDelete();
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
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              widget.type.path,
              arguments: widget.data,
            );
          },
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.r),
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0x13222327),
                  blurRadius: 12,
                  offset: Offset(0, 8.w),
                  spreadRadius: -4.r,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 105.w,
                    height: 40.w,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xfff8cc76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(36.r),
                          bottomLeft: Radius.circular(36.r),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.data.extras == '{}' ? '自动保存' : '手动保存',
                        style: TextStyle(
                          color: const Color(0xff222426),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ),
                widget.type == ArchiveType.qimen
                    ? Visibility(
                        visible: widget.data.toQiMen().extras.seal == 1,
                        child: Positioned(
                          left: 326.w,
                          top: 16.w,
                          bottom: 16.w,
                          child: Image.asset('assets/images/sealed.png'),
                        ),
                      )
                    : const SizedBox(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 36.w,
                    vertical: 30.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 2.w,
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xff222426),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Text(
                          widget.type.label,
                          style: TextStyle(
                            color: const Color(0xfff8cc76),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.w),
                      Visibility(
                        visible: widget.type == ArchiveType.bazi,
                        child: widget.type == ArchiveType.bazi
                            ? BaziArchive(data: widget.data.toBaZi())
                            : const SizedBox(),
                      ),
                      Visibility(
                        visible: widget.type == ArchiveType.liuyao,
                        child: widget.type == ArchiveType.liuyao
                            ? LiuyaoArchive(
                                data: widget.data.toSixLine(),
                              )
                            : const SizedBox(),
                      ),
                      Visibility(
                        visible: widget.type == ArchiveType.liuren,
                        child: widget.type == ArchiveType.liuren
                            ? LiurenArchive(
                                data: widget.data.toLiuRen(),
                              )
                            : const SizedBox(),
                      ),
                      Visibility(
                        visible: widget.type == ArchiveType.qimen,
                        child: widget.type == ArchiveType.qimen
                            ? QimenArchive(
                                data: widget.data.toQiMen(),
                              )
                            : const SizedBox(),
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
