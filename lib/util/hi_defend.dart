//异常捕获与日志收集
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HiDefend{
  run(Widget app){
    //框架异常捕获
    FlutterError.onError = (FlutterErrorDetails details) async{
      //线上环境走上报逻辑
      if(kReleaseMode){
        //转发至Zone
        //Zone表示一个代码执行的环境范围(沙箱)，我们使用Zone提供的handleUncaughtError语句，将Flutter框架的异常统一转发到当前的Zone
        Zone.current.handleUncaughtError(details.exception, details.stack!);
        //它就会把异常转到runZonedGuarded,最后在_reportError进行处理
      }else{
        //开发期间走console控制台抛出
        FlutterError.dumpErrorToConsole(details);
      }
    };
    runZonedGuarded((){
      runApp(app);
    }, (e,s) => _reportError(e,s));
  }
}
//通过接口上报异常 第三方bugly引入等
_reportError(Object error, StackTrace s) {
  print('kReleaseMode判断当前是否是Release 模式:$kReleaseMode');
  print('catch error:$error');
}