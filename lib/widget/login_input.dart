import 'package:flutter/material.dart';
import 'package:yu_bilibili/util/color.dart';

class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged; //聚焦时
  final bool lineStretch; //底部的线撑满整行
  final bool obscureText; //密码输入模式
  final TextInputType? keyboardType; //键盘输入类型
  final TextEditingController? controller;

  //其他参数可选，title,hint必填
  const LoginInput(this.title, this.hint,
      {Key? key,
      this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType,
      this.controller})
      : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode(); //获取聚焦
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //是否获取光标的监听
    _focusNode.addListener(() {
      print('has focus ${_focusNode.hasFocus}');
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus); //聚焦
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            //输入框底部的线
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      cursorColor: primaryColor,
      controller: widget.controller ?? null,
      autofocus: !widget.obscureText,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w300),
      //输入框的样式
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20, right: 20),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey)),
    ));
  }
}
