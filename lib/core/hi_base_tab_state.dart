import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yu_bilibili/http/core/hi_error.dart';
import 'package:yu_bilibili/util/color.dart';
import 'package:yu_bilibili/core/hi_state.dart';
import 'package:yu_bilibili/util/toast.dart';

//通用底层带分页和刷新的页面框架
///M作为Dao返回数据模型 L为列表数据模型 T为具体widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  ScrollController scrollController = ScrollController();
  bool loading = false;
  get contentChild;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      //获取偏差(差多少到底部) = 最大可滚动距离 - 当前滚动了的距离
      var dis = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      // print('dis:$dis');
      if (dis < 300 &&
          !loading &&
          //fix 当列表高度不满屏幕时不执行加载更多
          scrollController.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadData,
      color: primaryColor,
      child: contentChild,
    );
  }

  ///获取对应页码的数据
  Future<M> getData(int pageIndex);

  ///从MO中解析出list数据
  List<L> parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (loading) {
      print("上次加载还没完成...");
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('当前的页数是$currentIndex');
    try {
      var result = await getData(currentIndex);
      print('loadData():${result}');
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).length != 0) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      print(e);
      loading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      loading = false;
      showWarnToast(e.message);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
