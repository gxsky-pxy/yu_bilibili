import 'package:flutter/material.dart';
import 'package:yu_bilibili/core/hi_base_tab_state.dart';
import 'package:yu_bilibili/http/dao/notice_dao.dart';
import 'package:yu_bilibili/model/home_mo.dart';
import 'package:yu_bilibili/model/notice_mo.dart';
import 'package:yu_bilibili/widget/notice_card.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends HiBaseTabState<NoticeMo,BannerMo,NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(title: Text("通知")),
          Expanded(child: super.build(context))
        ],
      ),
    );
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
            NoticeCard(notices: dataList[index])),
  );

  @override
  Future<NoticeMo> getData(int pageIndex) async{
    NoticeMo result = await NoticeDao.getList(pageSize: 10,pageIndex: pageIndex);
    return result;
  }

  @override
  List<BannerMo> parseList(NoticeMo result) {
   return result.list;
  }
}
