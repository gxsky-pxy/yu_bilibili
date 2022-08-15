import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yu_bilibili/barrage/barrage_item.dart';
import 'package:yu_bilibili/barrage/barrage_view_util.dart';
import 'package:yu_bilibili/barrage/hi_socket.dart';
import 'package:yu_bilibili/barrage/ibarrage.dart';
import 'package:yu_bilibili/model/barrage_model.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  //弹幕显示行数
  final int lineCount;
  //速度
  final int speed;
  final String vid;
  //距离顶部
  final double top;
  //是否自动播放
  final bool autoPlay;

  const HiBarrage(
      {Key? key,
      this.lineCount = 4,
      this.speed = 800,
      required this.vid,
      this.top = 0,
      this.autoPlay = false})
      : super(key: key);

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height;
  late double _width;
  List<BarrageItem> _barrageItemList = []; //弹幕列表
  List<BarrageModel> _barrageModelList = []; //弹幕模型
  int _barrageIndex = 0; //是第几个弹幕
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hiSocket = HiSocket();
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    if (_hiSocket != null) {
      _hiSocket.close();
    }
    if (_timer != null) {
      _timer?.cancel();
    }

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width / 16 * 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          //防止Stack的child为空
          Container()
        ]..addAll(_barrageItemList),
      ),
    );
  }

  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      //是否立即发送
      //立即发送的优先展示
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }

    //收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    //弹幕不是暂停状态且是立即播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
      return;
    }
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    print('action:play');
    //计时器处于激活状态直接返回
    if (_timer != null && (_timer?.isActive ?? false)) return;
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        //将要发送的弹幕从集合中剔除
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        print('start: ${temp.content}');
      } else {
        //没弹幕了取消计时器
        print('all barrage are sent');
        _timer?.cancel();
      }
    });
  }

  //像屏幕上添加弹幕
  void addBarrage(BarrageModel temp) {
    //todo
    double perRowHeight = 30; //每行高度
    var line = _barrageIndex % widget.lineCount; //获取是第几行
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;
    //为每条弹幕生产一个id
    String id = '${_random.nextInt(10000)}:${temp.content}';
    var item = BarrageItem(
        id: id,
        top: top,
        child: BarrageViewUtil.barrageView(temp),
        barStatus:_barrageStatus == BarrageStatus.play?'play':'pause',
        onComplete: _onComplete);

    _barrageItemList.add(item);
    setState(() {});
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    //清空弹幕
    // _barrageItemList.clear();
    setState(() {});
    print('action:pause');
    _timer?.cancel();
  }

  @override
  void send(String messgae) {
    if (messgae == null) return;
    _hiSocket.send(messgae);
    _handleMessage(
        [BarrageModel(content: messgae, vid: '-1', priority: 1, type: 1)]);
  }

  void _onComplete(value) {
    print('Done:$value');
    //弹幕播完了从集合移除
    _barrageItemList.removeWhere((element) => element.id == value);
  }
}
