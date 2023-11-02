import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_bilibili/core/hi_base_tab_state.dart';
import 'package:yu_bilibili/http/dao/favorite_dao.dart';
import 'package:yu_bilibili/model/ranking_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:yu_bilibili/page/video_detail_page.dart';
import 'package:yu_bilibili/provider/theme_provider.dart';
import 'package:hi_base/color.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';
import 'package:yu_bilibili/widget/video_large_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends HiBaseTabState<RankingMo,VideoModel,FavoritePage> {
  late RouteChangeListener listener;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      if(pre?.page is VideoDetailPage && current.page is FavoritePage){
        loadData();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark()?HiColor.dark_bg:Colors.white70;
    return Column(
      //super.build(context)是父类的build 也就是HiBaseTabState里面的build
      children: [_buildNavigationBar(textColor),
      dataList.length == 0
          ?Center(heightFactor: 10,child: Text('还没有收藏哦',style: TextStyle(color: Colors.grey)))
          :Expanded(child: super.build(context))
      ],
    );
  }
  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    // TODO: implement dispose
    super.dispose();
  }
  @override
  // TODO: implement contentChild
  get contentChild => Container(
    child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        itemCount: dataList.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) =>
            VideoLargeCard(videoModel: dataList[index])),
  );



  @override
  Future<RankingMo> getData(int pageIndex) async{
    RankingMo result = await FavoriteDao.favoriteList(pageSize: 10,pageIndex: pageIndex);
    return result;
  }

  @override
  List<VideoModel> parseList(result) {
    return result.list;
  }

  _buildNavigationBar(Color textColor) {
    return NavigationBarPlus(
        color: textColor,
        child: Container(
          decoration: bottomBoxShadow(context),
          alignment: Alignment.center,
          child: Text('收藏',style: TextStyle(fontSize: 16),),
        )
    );
  }
}
