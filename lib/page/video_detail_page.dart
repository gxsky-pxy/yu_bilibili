import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/appbar.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';
import 'package:yu_bilibili/widget/video_view.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //黑色状态栏 仅安卓
    changeStatusBar(color: Colors.black,statusStyle: StatusStyle.DARK_CONTENT);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: Column(
            children: [
              //iOS 黑色状态栏
              NavigationBarPlus(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
              ),
              _videoView(),
              Text('视频详情页，vid:${widget.videoModel.vid}'),
              Text('视频详情页，title:${widget.videoModel.title}')
            ],
          )),
    );
  }
  _videoView() {
    var model = widget.videoModel;
    return VideoView(model.url!,cover: model.cover,overlayUI: videoAppBar(),);
  }
}

