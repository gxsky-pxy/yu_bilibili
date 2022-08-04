import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }
  @override
  Widget build(BuildContext context) {
    return  AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Column(
                children: [
                  //虚拟导航栏 为了占位置
                  NavigationBarPlus(
                    color: Colors.black,
                    statusStyle: StatusStyle.LIGHT_CONTENT,
                    height: Platform.isAndroid ? 0 : 46,
                  ),
                  _videoView(),
                  Text('视频详情页，vid:${widget.videoModel.vid}'),
                  Text('视频详情页，title:${widget.videoModel.title}')
                ],
          ),
        ));
  }
  _videoView() {
    var model = widget.videoModel;
    return VideoView(model.url!,cover: model.cover,overlayUI: videoAppBar(),);
  }
}

