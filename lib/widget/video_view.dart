import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';
import 'package:yu_bilibili/util/color.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/hi_video_controls.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay; //自动播放
  final bool looping; //是否轮播
  final double aspectRatio;
  final Widget? overlayUI;
  const VideoView(this.url,
      {Key? key,
      required this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      this.overlayUI})
      : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  //视频封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover),
      );
  //进度条颜色配置
  get _progressColors => ChewieProgressColors(
      playedColor: primaryColor,
      handleColor: primaryColor,
      backgroundColor: Colors.grey,
      bufferedColor: Colors.white24);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化播放器设置
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        placeholder: _placeholder,
        allowMuting: false, //静音播放
        allowPlaybackSpeedChanging: false, //播放速度
        customControls: MaterialControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,
          bottomGradient: blackLinearGradient(),
          overlayUI: widget.overlayUI,
        ),
        materialProgressColors: _progressColors);
    _chewieController.addListener(_fullScreenListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _chewieController.removeListener(_fullScreenListener); //先移除监听 再释放控制器
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  void _fullScreenListener() {
    Size size = MediaQuery.of(context).size;
    if (size.width > size.height) {
      //屏幕的宽度大于高度的时候  强制转为竖屏
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    }
  }
}
