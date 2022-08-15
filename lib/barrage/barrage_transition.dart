import 'package:flutter/material.dart';

///弹幕移动动效
class BarrageTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ValueChanged onComplete;
  final String status;
  const BarrageTransition(
      {Key? key,
      required this.child,
      required this.duration,
      required this.onComplete,
      required this.status})
      : super(key: key);

  @override
  State<BarrageTransition> createState() => BarrageTransitionState();
}

class BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //创建动画控制器
    _animationController = AnimationController(duration: widget.duration,vsync: this)
      ..addStatusListener((status) {
        //动画执行完毕之后的回调
        if (status == AnimationStatus.completed) {
          widget.onComplete('');
        }
      });
    //定义从右向左的补间动画
    var begin = Offset(1.0, 0);
    var end = Offset(-1.0, 0);
    _animation = Tween(begin: begin, end: end).animate(_animationController);
  }
@override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.status == 'pause'){
      _animationController.stop(canceled: true);
    }else{
      _animationController.forward();
    }
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
