import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';
import 'package:yu_bilibili/http/dao/home_dao.dart';
import 'package:yu_bilibili/model/home_mo.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:yu_bilibili/page/home_tab_page.dart';
import 'package:yu_bilibili/provider/theme_provider.dart';
import 'package:hi_base/color.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/hi_tab.dart';
import 'package:yu_bilibili/widget/loading_container.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';
import 'package:hi_base/hi_state.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin ,WidgetsBindingObserver{
  var listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);//监听应用是否隐藏到了后台
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      print('home:current：${current.page}');
      print('home:pre：${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页：onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页被压后台了 onPause');
      }
    });
    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(this.listener);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  //监听系统dark mode变化
  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    context.read<ThemeProvider>().darkModeChange();
    super.didChangePlatformBrightness();
  }

  //监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState:$state');
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: themeProvider.isDark()?SystemUiOverlayStyle.light:SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
       ),
      // value: SystemUiOverlayStyle.dark.copyWith(
      //   statusBarColor: Colors.transparent,
      // ),
        child: LoadingContainer(
          isLoading: _isLoading,
          child: Column(
            children: [
              NavigationBarPlus(
                child: _appBar(),
                height: 50,
                color: themeProvider.isDark()?HiColor.dark_bg:Colors.transparent,
                statusStyle: StatusStyle.DARK_CONTENT,
              ),
              Container(
                decoration: bottomBoxShadow(context),
                // color: Colors.white,
                padding: EdgeInsets.only(top: 30),
                child: _tabBar(),
              ),
              Flexible(
                  child: TabBarView(
                      controller: _controller,
                      children: categoryList.map((tab) {
                        return HomeTabPage(
                            categoryName: tab.name,
                            bannerList: tab.name == '推荐' ? bannerList : null);
                      }).toList()))
            ],
          ),
        ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  ///自定义顶部tab
  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(
          text: tab.name,
        );
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      print('loadData:${result}');
      if (result.categoryList != null) {
        //tab长度变化后需要重新创建tabController
        _controller = TabController(
            length: result.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList ?? [];
        bannerList = result.bannerList ?? [];
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _appBar() {
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                //点击头像跳到“我的”
                if (widget.onJumpTo != null) {
                  widget.onJumpTo!(3);
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: Image(
                  height: 46,
                  width: 46,
                  image: AssetImage('images/avatar.png'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    height: 32,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.search, color: Colors.grey),
                    decoration: BoxDecoration(color: Colors.grey[100]),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                _mockCrash();
              },
              child:             Icon(
                Icons.explore_outlined,
                color: Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: (){
                HiNavigator.getInstance().onJumpTo(RouteStatus.notice);
              },
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ));
  }
}

//模拟Crash
void _mockCrash() async{
  //只抛异常不捕获，main.dart的runZonedGuarded就会捕获
  Future.delayed(Duration(seconds: 1)).then((value) => throw StateError('main那边的:runZonedGuarded异步捕获异常,$value'));

  throw StateError('this is a dart exception.');
}