import 'package:flutter/material.dart';
import 'package:yu_bilibili/db/hi_cache.dart';
import 'package:yu_bilibili/http/core/hi_error.dart';
import 'package:yu_bilibili/http/dao/login_dao.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';
import 'package:yu_bilibili/util/string_util.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/widget/appbar.dart';
import 'package:yu_bilibili/widget/login_button.dart';
import 'package:yu_bilibili/widget/login_effect.dart';
import 'package:yu_bilibili/widget/login_input.dart';

///登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;

  var _codeContrller = new TextEditingController(); //field控制器
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiCache.preInit(); //预创建缓存

    //记住用户名，如果缓存有用户名就读取并填写
    var name = HiCache.getInstance().get('userName');
    if (name != null && isNotEmpty(name)) {
      _codeContrller.text = name;
      setState(() {
        userName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HiCache.preInit(); //预创建缓存
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户',
              controller: _codeContrller, //绑定控制器
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
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: LoginButton(
                  '登录',
                  enable: loginEnable,
                  onPressed: send,
                ))
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      print('false');
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName!, password!);
      print(result);
      if (result['code'] == 0) {
        print('登录成功');
        showToast('登录成功');
        HiCache.getInstance().setString('userName', userName!);
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
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
}
