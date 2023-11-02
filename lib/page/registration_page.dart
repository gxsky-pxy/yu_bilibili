import 'package:flutter/material.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:yu_bilibili/http/dao/login_dao.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:hi_base/string_util.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/widget/appbar.dart';
import 'package:yu_bilibili/widget/login_button.dart';
import 'package:yu_bilibili/widget/login_effect.dart';
import 'package:yu_bilibili/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool enable = false;
  String? userName;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      }),
      body: Container(
        child: ListView(
          //listview可以自适应键盘弹起防止遮挡，不至于在输入框聚焦的时候使得输入框错位
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户名',
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              '确认密码',
              '请再次输入密码',
              obscureText: true,
              onChanged: (text) {
                rePassword = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              '慕课网ID',
              '请输入你的慕课网用户ID',
              keyboardType: TextInputType.number, //键盘类型设置数字键盘
              onChanged: (text) {
                imoocId = text;
                checkInput();
              },
            ),
            LoginInput(
              '课程订单号',
              '请输入课程订单号后四位',
              lineStretch: true,
              keyboardType: TextInputType.number, //键盘类型设置数字键盘
              onChanged: (text) {
                orderId = text;
                checkInput();
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                '注册',
                enable: enable,
                onPressed: checkParams,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enables;
    if (isNotEmpty(userName) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enables = true;
    } else {
      enables = false;
    }
    setState(() {
      enable = enables;
    });
  }

  void send() async {
    try {
      var result =
          await LoginDao.registtation(userName!, password!, imoocId!, orderId!);
      if (result['code'] == 0) {
        print('注册成功');
        showToast('注册成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.login);
      } else {
        print(result['msg']);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId?.length != 4) {
      tips = '请输入订单号的后四位';
    }
    if (tips != null) {
      print(tips);
      return;
    }
    send();
  }
}
