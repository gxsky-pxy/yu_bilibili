import 'package:flutter/material.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:yu_bilibili/page/favorite_page.dart';
import 'package:yu_bilibili/page/home_page.dart';
import 'package:yu_bilibili/page/profile_page.dart';
import 'package:yu_bilibili/page/ranking_page.dart';
import 'package:yu_bilibili/util/color.dart';

//底部导航
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primaryColor;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: 0);
  List<Widget> _pages = [];
  bool _hasBuild = false; //初始化
  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(
        onJumpTo: (index) => _onJumpTo(index, pageChange: false),
      ),
      RankingPage(),
      FavoritePage(),
      ProfilePage()
    ];
    if (!_hasBuild) {
      //页面第一次打开的时候通知打开的是哪个tab
      HiNavigator.getInstance()
          .onBottomTagChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor),
        label: title);
  }

  void _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      //如果是点击底部tab的时候，要使用pageview的控制器跳转到对应的页面
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTagChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
