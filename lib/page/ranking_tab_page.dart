import 'package:flutter/material.dart';
import 'package:yu_bilibili/core/hi_base_tab_state.dart';
import 'package:yu_bilibili/http/dao/ranking_dao.dart';
import 'package:yu_bilibili/model/ranking_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;
  const RankingTabPage({Key? key, required this.sort}) : super(key: key);

  @override
  State<RankingTabPage> createState() => _RankingTabPageState();
}

class _RankingTabPageState extends HiBaseTabState<RankingMo,VideoModel,RankingTabPage> {
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
    RankingMo result = await RankingDao.get(widget.sort,pageIndex: pageIndex,pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}
