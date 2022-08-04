import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yu_bilibili/http/core/hi_error.dart';
import 'package:yu_bilibili/http/dao/home_dao.dart';
import 'package:yu_bilibili/model/home_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/util/color.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/widget/hi_banner.dart';
import 'package:yu_bilibili/widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;
  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> with AutomaticKeepAliveClientMixin{
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  ScrollController _scrollController = ScrollController();
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      //获取偏差(差多少到底部) = 最大可滚动距离 - 当前滚动了的距离
      var dis = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
      // print('dis:$dis');
      if(dis<300 && !_loading){
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _loadData,
      color: primaryColor,
      child: ListView(
        controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),//解决如果数据不足一屏的时候没办法下拉刷新
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          children: [
            StaggeredGrid.count(
              crossAxisCount: 2, //表格布局列的数量
              axisDirection: AxisDirection.down,
              mainAxisSpacing: 4, //垂直子Widge之间的间距
              crossAxisSpacing: 4, //水平子Widget之间的间距
              children: [
                if (widget.bannerList != null)
                  StaggeredGridTile.fit(crossAxisCellCount: 2, child: _banner()),
                ...videoList.map((videoMo) => StaggeredGridTile.fit(
                    crossAxisCellCount: 1, child: VideoCard(videoModel: videoMo))),
              ],
            ),
          ],
        )
    );
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList!));
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('当前的页数是$currentIndex');
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      print('loadData():${result}');
      setState(() {
        if (loadMore) {
          if (result.videoList.isNotEmpty) {
            videoList = [...videoList, ...result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList;
        }
      });
      Future.delayed(Duration(milliseconds: 1000),(){
        _loading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      _loading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      _loading = false;
      showWarnToast(e.message);
    }
  }

  List<Widget> _getList() {
    List<Widget> arr = [];
    for (var i = 0; i < videoList.length; i++) {
      print(i);
      if (widget.bannerList != null && i == 0) {
        arr.add(StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 2,
          child: _banner(),
        ));
      } else {
        arr.add(StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1.5,
          child: VideoCard(videoModel: videoList[i]),
        ));
      }
    }
    print(arr.length);
    return arr;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
