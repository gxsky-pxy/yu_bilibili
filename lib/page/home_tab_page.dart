import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yu_bilibili/core/hi_base_tab_state.dart';
import 'package:yu_bilibili/http/dao/home_dao.dart';
import 'package:yu_bilibili/model/home_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
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

class _HomeTabPageState extends HiBaseTabState<HomeMo,VideoModel,HomeTabPage>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.categoryName);
    print(widget.bannerList);
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList!));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // TODO: implement contentChild
  get contentChild => ListView(
    controller: scrollController,
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
          ...dataList.map((videoMo) => StaggeredGridTile.fit(
              crossAxisCellCount: 1, child: VideoCard(videoModel: videoMo))),
        ],
      ),
    ],
  );

  @override
  Future<HomeMo> getData(int pageIndex) async{
    HomeMo result = await HomeDao.get(widget.categoryName,pageIndex: pageIndex,pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList;
  }
}
