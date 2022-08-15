import 'package:flutter/material.dart';
import 'package:yu_bilibili/barrage/barrage_transition.dart';
import 'package:yu_bilibili/util/EventBus.dart';

///弹幕widget
class BarrageItem extends StatefulWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;
  final String barStatus;
  const BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000),
      required this.child,
      this.barStatus = 'pause'})
      : super(key: key);

  @override
  State<BarrageItem> createState() => _BarrageItemState();
}

// //fix 动画状态错乱
// var _key = GlobalKey<BarrageTransitionState>();

class _BarrageItemState extends State<BarrageItem> {
  String barStatus = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barStatus = widget.barStatus;
    bus.on('changeVideoPlayOrPause', (arg) {
      barStatus = arg;
      if(mounted){
        setState(() {});
      }
    });
  }
  @override
  void dispose() {
    bus.off('changeVideoPlayOrPause');
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: widget.top,
        child: BarrageTransition(
          // key: _key,
          key:Key('barrage_item_'+widget.id),
          child: widget.child,
          onComplete: (v) {
            widget.onComplete(widget.id);
          },
          status: barStatus,
          duration: widget.duration,
        ));
  }
}
