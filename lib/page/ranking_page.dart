import 'package:flutter/material.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/hi_tab.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with TickerProviderStateMixin{
  late TabController _controller;
  static const TABS = [
    {"key":"like","name":"最热"},
    {"key":"pubdate","name":"最新"},
    {"key":"favorite","name":"收藏"}
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: TABS.length, vsync: this);
  }
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return NavigationBarPlus(
      child: Container(
        decoration: bottomBoxShadow(),
        alignment: Alignment.center,
        child: _tabBar(),
      )
    );
  }
  ///自定义顶部tab
  _tabBar() {
    return HiTab(
      TABS.map<Tab>((tab) {
        return Tab(
          text: tab["name"],
        );
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
    );
  }

  _buildTabView() {
    return Text('AAAAAA');
  }
  //   return Flexible(
  //       child: TabBarView(
  //           controller: _controller,
  //           children: TABS.map((tab) {
  //             return RankingTabPage(sort: tab['key'] as String);
  //           }).toList()));
  // }
}
