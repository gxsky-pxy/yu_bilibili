import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) =>
          Container(color: Colors.grey[200]),
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) =>
          Icon(Icons.error),
      imageUrl: url);
}

//黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

///修改状态栏
void changeStatusBar(
    {StatusStyle statusStyle: StatusStyle.DARK_CONTENT,
    BuildContext? context}) {
  //沉浸式状态栏样式
  var brightness;
  if (Platform.isIOS) {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.dark
        : Brightness.light;
  } else {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.light
        : Brightness.dark;
  }
  //一个全局属性 功能很强大 可以设置横竖屏 隐藏底部虚拟栏 修改状态栏样式等
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //此处使用了修改状态栏样式setSystemUIOverlayStyle 此方法不建议使用 建议用AnnotatedRegion
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent, //该属性仅用于 **Android** 设备，顶部状态栏颜色
    statusBarBrightness: brightness, //该属性仅用于 **iOS** 设备顶部状态栏亮度
    statusBarIconBrightness: brightness, //该属性仅用于 **Android** 底部状态栏图标样式颜色
  ));
}
