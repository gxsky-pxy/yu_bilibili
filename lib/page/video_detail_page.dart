import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:yu_bilibili/barrage/barrageSwitch.dart';
import 'package:yu_bilibili/barrage/barrage_input.dart';
import 'package:yu_bilibili/barrage/hi_barrage.dart';
import 'package:yu_bilibili/http/core/hi_error.dart';
import 'package:yu_bilibili/http/dao/favorite_dao.dart';
import 'package:yu_bilibili/http/dao/like_dao.dart';
import 'package:yu_bilibili/http/dao/video_detail_dao.dart';
import 'package:yu_bilibili/model/video_detail_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/util/EventBus.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/appbar.dart';
import 'package:yu_bilibili/widget/expandable_content.dart';
import 'package:yu_bilibili/widget/hi_tab.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';
import 'package:yu_bilibili/widget/video_header.dart';
import 'package:yu_bilibili/widget/video_large_card.dart';
import 'package:yu_bilibili/widget/video_toolbar.dart';
import 'package:yu_bilibili/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论288"];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;
  List<VideoModel> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();
  bool _inputShowing = false;
  String _videoStatusBefore = 'pause';

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: videoModel?.url != null
              ? Column(
                  children: [
                    //虚拟导航栏 为了占位置
                    NavigationBarPlus(
                      color: Colors.black,
                      statusStyle: StatusStyle.LIGHT_CONTENT,
                      height: Platform.isAndroid ? 0 : 46,
                    ),
                    _buildVideoView(),
                    _buildTabNavigation(),
                    Flexible(
                        child: TabBarView(
                      controller: _controller,
                      children: [
                        _buildDetailList(),
                        Container(
                          child: Text('敬请期待...'),
                        )
                      ],
                    ))
                  ],
                )
              : Container(),
        ));
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoView(
      model!.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
      barrageUI: HiBarrage(key: _barrageKey, vid: model.vid, autoPlay: false),
      onChanged: (status) {
        setState(() {
          _videoStatusBefore = status;
        });
        //点击视频开始的时候才播放弹幕
        if (status == 'play') {
          _barrageKey.currentState?.play();
        } else {
          _barrageKey.currentState?.pause();
        }
      },
    );
  }

  _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tabBar(), _buildBarrageBtn()],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
        tabs.map<Tab>((name) {
          return Tab(
            text: name,
          );
        }).toList(),
        controller: _controller,
        unselectedLabelColor: Colors.black54);
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      Container(
        child: VideoHeader(
          owner: videoModel!.owner,
        ),
      ),
      ExpandableContent(
        mo: videoModel!,
      ),
      VideoToolBar(
        detailMo: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(videoModel!.vid);
      print(result);
      setState(() {
        videoDetailMo = result;
        //更新旧的数据
        videoModel = result.videoInfo;
        videoList = result.videoList;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  ///点赞
  _doLike() async {
    try {
      var result = await LikeDao.like(videoModel!.vid, !videoDetailMo!.isLike);
      print(result);
      videoDetailMo!.isLike = !videoDetailMo!.isLike;
      if (videoDetailMo!.isLike) {
        videoModel!.like += 1;
      } else {
        videoModel!.like -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  ///取消点赞
  void _onUnLike() {}

  ///收藏
  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(
          videoModel!.vid, !videoDetailMo!.isFavorite);
      print(result);
      videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite;
      if (videoDetailMo!.isFavorite) {
        videoModel!.favorite += 1;
      } else {
        videoModel!.favorite -= 1;
      }
      setState(() {
        videoDetailMo = videoDetailMo;
        videoModel = videoModel;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  //推荐视频列表
  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inputShowing,
        onShowInput: () {
          //记一下输入前的播放状态
          var videoStatus = _videoStatusBefore;
          //输入弹幕的时候r如果视频是在播放中则暂停视频播放 否则状态不变
          videoStatus == 'play' ? bus.emit('onVideoPlay', 'pause') : null;
          setState(() {
            _inputShowing = true;
          });
          //遮罩层插件
          HiOverlay.show(context, child: BarrageInput(onTabClose: () {
            setState(() {
              _inputShowing = false;
            });
          })).then((value) {
            //这里用到了导航器返回时向上一级页面传值的操作。
            //1. HiOverlay的show方法包装的是Navigator.of(context).push(_HiOverlay(child))，
            // 然后返回的是Future<String?> 代表着下一级页面的返回值；
            //2. 我们在video_detail_page中通过HiOverlay.show(context, child: BarrageInput())
            // 调用HiOverlay的show的时候传递了一个BarrageInput页面；
            //3.   BarrageInput在关闭的时候会通过 Navigator.pop(context, text)向上一节页面传递text：
            print('---input ：$value');
            //存在弹幕发送的时候
            if (value != null) {
              _barrageKey.currentState!.send(value);
            }
            //输入结束后恢复原来的状态
            bus.emit('onVideoPlay', videoStatus);
          });
        },
        onBarrageSwitch: (open) {
          print('open: $open');
          // if(open){
          //   _barrageKey.currentState!.play();
          // }else{
          //   _barrageKey.currentState!.pause();
          // }
        });
  }
}
