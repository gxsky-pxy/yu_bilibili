import 'package:flutter/material.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/util/view_util.dart';

class ExpandableContent extends StatefulWidget {
  final VideoModel mo;
  const ExpandableContent({Key? key, required this.mo}) : super(key: key);

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  bool _expand = false;
  //用来管理animation
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {
      //监听动画的变化
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        children: [
          _buildTitle(),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          _buildInfo(),
          _buildDes()
        ],
      ),
    );
  }

  _buildTitle() {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //通过Expand让Text获得最大宽度，以便显示省略号
          Expanded(
              child: Text(
                widget.mo.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
            _expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 16,
          )
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        //执行动画
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var style = TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.mo.createTime.length > 10
        ? widget.mo.createTime.substring(5, 10)
        : widget.mo.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.mo.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.mo.reply),
        Padding(padding: EdgeInsets.only(left: 10)),
        Text('$dateStr', style: style)
      ],
    );
  }

  _buildDes() {
    var child = _expand
        ? Text(widget.mo.desc,
            style: TextStyle(fontSize: 12, color: Colors.grey))
        : null;
    //构建动画通用widget
    return AnimatedBuilder(
        animation: _controller.view,
        child: child,
        builder: (BuildContext context, Widget? child) {
          return Align(
            heightFactor: _heightFactor.value,
            //fix从布局之上的位置开始展开
            alignment: Alignment.topCenter,
            child: Container(
              //会盛满宽度后，让内容左上对其
              alignment: Alignment.topLeft,
              padding:  EdgeInsets.only(top: 8),
              child: child,
              ),
            );
        });
  }
}
