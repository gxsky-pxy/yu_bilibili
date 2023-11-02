import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

///可动态改变位置的header组件
///性能优化:局部刷新的应用@刷新原理
class HiFlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;
  const HiFlexibleHeader({Key? key, required this.name, required this.face, required this.controller}) : super(key: key);

  @override
  State<HiFlexibleHeader> createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BUTTOM = 40;
  static const double MIN_BUTTOM = 10;

  //滚动范围
  static const MAX_OFFSET = 80;
  double _dybottom = MAX_BUTTOM;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.addListener(() {
      var offset =  widget.controller.offset;
      //算出padding变化0-1
      var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
      //格局dyOffset算出具体的变化的padding值
      var dy = dyOffset * (MAX_BUTTOM - MIN_BUTTOM);
      //临界值保护
      if(dy > (MAX_BUTTOM - MIN_BUTTOM)){
        dy = MAX_BUTTOM - MIN_BUTTOM;
      }else if(dy<0){
        dy = 0;
      }
      setState(() {
        _dybottom = MIN_BUTTOM + dy;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dybottom,left: 10),
      color: Colors.transparent,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(widget.face,width: 46,height: 46),
          ),
          hiSpace(width: 8),
          Text(widget.name,style: TextStyle(fontSize: 11),)
        ],
      ),
    );
  }
}
