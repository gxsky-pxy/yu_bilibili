import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_bilibili/http/dao/ranking_dao.dart';
import 'package:yu_bilibili/page/ranking_tab_page.dart';
import 'package:yu_bilibili/provider/theme_provider.dart';
import 'package:yu_bilibili/util/color.dart';
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
    RankingDao.get("like");
  }
  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark()?HiColor.dark_bg:Colors.white;
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(textColor), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar(Color textColor) {
    return NavigationBarPlus(
        color:textColor,
      child: Container(
        decoration: bottomBoxShadow(context),
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
    return Flexible(
        child: TabBarView(
            controller: _controller,
            children: TABS.map((tab) {
              return RankingTabPage(sort: tab['key'] as String);
            }).toList()));
  }
}
