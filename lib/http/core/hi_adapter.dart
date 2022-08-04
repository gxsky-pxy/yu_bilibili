//统一网络层返回格式
import 'dart:convert';

import 'package:yu_bilibili/http/request/base_request.dart';

///网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  T? data;
  BaseRequest request;
  int? statusCode;
  String? statusMessage;
  late dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }

  //可选参数，传参时需要带上参数名 data:xxxx
  HiNetResponse(
      {this.data,
      required this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});
}
