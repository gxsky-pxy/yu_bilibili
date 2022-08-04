import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yu_bilibili/core/hi_state.dart';
import 'package:yu_bilibili/http/core/hi_error.dart';
import 'package:yu_bilibili/http/dao/home_dao.dart';
import 'package:yu_bilibili/model/home_mo.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:yu_bilibili/page/home_tab_page.dart';
import 'package:yu_bilibili/util/color.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/loading_container.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: LoadingContainer(
          isLoading: _isLoading,
          child: Column(
            children: [
              NavigationBarPlus(
                child: _appBar(),
                height: 50,
                color: Colors.white,
                statusStyle: StatusStyle.DARK_CONTENT,
              ),
              Container(
                color: Colors.white,
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

  _tabBar() {
    return TabBar(
        controller: _controller,
        isScrollable: true,
        labelColor: Colors.black,
        indicatorColor: primaryColor,
        indicatorPadding: EdgeInsets.only(left: 10, right: 10),
        indicatorWeight: 3,
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
              child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: TextStyle(fontSize: 16),
            ),
          ));
        }).toList());
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
            Icon(
              Icons.explore_outlined,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
            )
          ],
        ));
  }
}
