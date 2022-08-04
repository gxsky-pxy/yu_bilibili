import 'package:yu_bilibili/http/core/dio_adapter.dart';
import 'package:yu_bilibili/http/core/hi_adapter.dart';
import 'package:yu_bilibili/http/core/hi_error.dart';
import 'package:yu_bilibili/http/request/base_request.dart';

///1.支持网络库插拔设计，且不干扰业务层
///2.基于配置请求请求，简洁易用
///3.Adapter设计，扩展性强
///4.统一异常和返回处理
class HiNet {
  //匿名内部类
  HiNet._();
  static HiNet? _instance;

  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      // response = await e.data;
      printLog('错误：${e}');
    } catch (e) {
      //其它异常
      error = e;
      printLog('其他异常：$e');
    }
    if (response == null) {
      printLog('response=null：$error');
    }
    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    ///使用Dio发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:' + log.toString());
  }
}
