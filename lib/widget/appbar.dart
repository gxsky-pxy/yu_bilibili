//自定义顶部appbar
import 'package:flutter/material.dart';
import 'package:yu_bilibili/util/color.dart';
import 'package:yu_bilibili/util/view_util.dart';

appBar(String title, String rightTitle, VoidCallback? rightButtonClick) {
  return AppBar(
    backgroundColor: primaryColor,
    //让tltle居左
    centerTitle: false,
    titleSpacing: 0,
    leading: BackButton(),
    title: Text(
      title,
      style: TextStyle(fontSize: 18),
    ),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

//视频详情页appBar
videoAppBar() {
  return Container(
    padding: EdgeInsets.only(right: 8),
    decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(
          color: Colors.white,
        ),
        Row(
          children: [
            Icon(Icons.live_tv_rounded,color: Colors.white,size: 20,),
            Padding(padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.more_vert_rounded,color: Colors.white,size: 20,),
            )
          ],
        )
      ],
    ),
  );
}