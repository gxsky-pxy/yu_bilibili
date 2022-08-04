import 'package:flutter/material.dart';
import 'package:yu_bilibili/db/hi_cache.dart';
import 'package:yu_bilibili/http/dao/login_dao.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/navigator/bottom_navigator.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:yu_bilibili/page/login_page.dart';
import 'package:yu_bilibili/page/registration_page.dart';
import 'package:yu_bilibili/page/video_detail_page.dart';
import 'package:yu_bilibili/util/toast.dart';

void main() {
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);
  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        //进行初始化
        future: HiCache.preInit(), //在HiCache初始化之前 返回的会是loading
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
          return MaterialApp(home: widget);
        });
  }
}

//RouterDelegate定义应用程序中的路由行为
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  //为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routerStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        this.videoModel = args?['videoMo'];
      }
      notifyListeners();
    }));
  }
  RouteStatus _routerStatus = RouteStatus.registration;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index); //index-1 只将当前页面的上一个页面删除
    }
    var page; //要跳转的页面

    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其他页面出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(const BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    }
    //重新创建一个数据，否则pages因引用没有改变路由没有生效
    tempPages = [...tempPages, page];
    //通知路由发生变化,传入新栈和旧栈
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              //登录页未登录返回拦截
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast('请先登录');
                  return false;
                }
              }
            }
            //必须在路由上调用 didPop 以确定弹出是否成功
            if (!route.didPop(result)) {
              return false;
            }
            var oldPages = [...pages];
            //返回页面的时候移除栈顶
            pages.removeLast();
            //通知路由变化
            HiNavigator.getInstance().notify(pages, oldPages);
            return true;
          },
        ),
        //fix Android物理返回键，无法返回上一页问题@https://github.com/flutter/flutter/issues/66349
        onWillPop: () async =>
            !(await navigatorKey.currentState?.maybePop() ?? false));
  }

  RouteStatus get routeStatus {
    if (_routerStatus != RouteStatus.registration && !hasLogin) {
      return _routerStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routerStatus = RouteStatus.detail;
    } else {
      return _routerStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null; //登录令牌不为空

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = "/";
  BiliRoutePath.detail() : location = "detail";
}
