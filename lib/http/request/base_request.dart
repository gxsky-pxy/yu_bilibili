import 'package:hi_net/request/hi_base_request.dart';
import 'package:yu_bilibili/http/dao/login_dao.dart';
import 'package:yu_bilibili/util/hi_constants.dart';

abstract class BaseRequest extends HiBaseRequest{
@override
  String url() {
  //需要登录的时候
    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    // TODO: implement url
    return super.url();
  }

  Map<String, dynamic> header = {
    HiConstants.authTokenK: HiConstants.authTokenV,
    HiConstants.courseFlagK: HiConstants.courseFlagV
  };
}