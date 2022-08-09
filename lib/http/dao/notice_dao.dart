import 'package:yu_bilibili/http/core/hi_net.dart';
import 'package:yu_bilibili/http/request/notice_request.dart';
import 'package:yu_bilibili/model/notice_mo.dart';

//https://api.devio.org/uapi/fa/notice?pageIndex=1&pageSize=10
class NoticeDao {
  static getList({int pageIndex = 1,int pageSize = 10}) async{
     NoticeRequest request = NoticeRequest();
     request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
     print('收藏列表是 $result');
     return NoticeMo.fromJson(result['data']);

  }
}