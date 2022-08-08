import 'package:flutter/material.dart';
import 'package:yu_bilibili/util/view_util.dart';
import 'package:yu_bilibili/widget/navigation_bar.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(title: Text("通知")),
          Text('实打实打算')
        ],
      ),
    );
  }
}
