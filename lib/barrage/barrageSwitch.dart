import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class BarrageSwitch extends StatefulWidget {
  ///初始时是否展开
  final bool initSwitch;

  ///是否为输入中
  final bool inoutShowing;

  ///输入框切换回调
  final VoidCallback onShowInput;

  ///展开与伸缩状态切换回调
  final ValueChanged<bool> onBarrageSwitch;

  const BarrageSwitch(
      {Key? key,
      this.initSwitch = true,
      this.inoutShowing = false,
      required this.onShowInput,
      required this.onBarrageSwitch})
      : super(key: key);

  @override
  State<BarrageSwitch> createState() => _BarrageSwitchState();
}

class _BarrageSwitchState extends State<BarrageSwitch> {
  late bool _barrageSwitch;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //是否展开
    _barrageSwitch = widget.initSwitch;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(left: 8,right: 8),
      decoration: BoxDecoration(border: Border.all(width: 1,color:Colors.grey[300]!),borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          _switchText(),
          _switchIcon()
        ],
      ),
    );
  }

  _switchText() {
    var text = widget.inoutShowing?'弹幕输入中':'点我发弹幕';
      return _barrageSwitch? GestureDetector(
        onTap: (){
          setState(() {
            widget.onShowInput();
          });
        },
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text(text,style: TextStyle(color: Colors.grey,fontSize: 12),),
        ),
      ):Container();

  }

  _switchIcon() {
    return GestureDetector(
      onTap: (){
        setState(() {
          _barrageSwitch = !_barrageSwitch;
        });
        widget.onBarrageSwitch(_barrageSwitch);
      },
      child: Icon(Icons.live_tv_rounded,color: _barrageSwitch?primaryColor:Colors.grey),
    );
  }
}
