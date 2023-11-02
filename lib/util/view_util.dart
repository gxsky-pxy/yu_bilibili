import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yu_bilibili/provider/theme_provider.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

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

///底部阴影
BoxDecoration? bottomBoxShadow(BuildContext context) {
  var themeProvider = context.watch<ThemeProvider>();
  if(themeProvider.isDark()){
    return null;
  }
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: Offset(0, 5), //xy轴偏移
        blurRadius: 5.0, //阴影模糊程度
        spreadRadius: 1 //阴影扩散程度
    )
  ]);
}
