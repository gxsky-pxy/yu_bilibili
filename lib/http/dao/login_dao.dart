import 'package:yu_bilibili/db/hi_cache.dart';
import 'package:yu_bilibili/http/core/hi_net.dart';
import 'package:yu_bilibili/http/request/base_request.dart';
import 'package:yu_bilibili/http/request/login_request.dart';
import 'package:yu_bilibili/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";

  //登录
  static login(String userName, String password) {
    return _send(userName, password);
  }

  //注册
  static registtation(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password,
        imoocId: imoocId, orderId: orderId); //可选参数传入需要指定key
  }

  static _send(String userName, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }
    request
        .add("userName", userName)
        .add("password", password)
        .add("imoocId", imoocId ?? '')
        .add("orderId", orderId ?? '');

    var result = await HiNet.getInstance().fire(request);
    print('结果$result');

    if (result['code'] == 0 && result['data'] != null) {
      print('这里这里');
      //保存登录令牌
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
      //令牌保存后，如何保持登录态？在base_request设置
    }
    return result;
  }

  //获取登录令牌
  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
