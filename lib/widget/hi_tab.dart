import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yu_bilibili/util/color.dart';

class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double? fontSize;
  final double? insets;
  final double? borderWidth;
  final Color? unselectedLabelColor;
  const HiTab(this.tabs,
      {Key? key,
        this.controller,
        this.fontSize = 13,
        this.borderWidth = 2,
        this.insets = 15,
        this.unselectedLabelColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: primaryColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(fontSize: fontSize),
        indicatorColor: primaryColor,
        indicatorPadding: EdgeInsets.only(left: 15, right: 15),
        indicatorWeight: 3,
        tabs: tabs);
  }
}
