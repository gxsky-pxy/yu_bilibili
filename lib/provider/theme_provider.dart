import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:yu_bilibili/db/hi_cache.dart';
import 'package:hi_base/color.dart';
import 'package:yu_bilibili/util/hi_constants.dart';
extension ThemeModeExtension on ThemeMode{
  String get value => <String>['System','Light','Dark'][index];
}

class ThemeProvider extends ChangeNotifier{
  ThemeMode? _themeMode;
  var _platformBrightness = SchedulerBinding.instance.window.platformBrightness;

  //系统dark mode发生变化 及时更新主题
  void darkModeChange(){
    if(_platformBrightness != SchedulerBinding.instance.window.platformBrightness){
      _platformBrightness = SchedulerBinding.instance.window.platformBrightness;
      notifyListeners();
    }
  }
  bool isDark(){
    if(_themeMode == ThemeMode.system){
      //获取系统的Dark Mode
      return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  //获取主题模式
  ThemeMode getThemeMode(){
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch(theme){
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    // return _themeMode = ThemeMode.system;
    return _themeMode!;
  }
  ///设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }
  ///获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        //Tab指示器的颜色
        indicatorColor: isDarkMode ? primaryColor[50] : white,
        //页面背景色
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white);
    return themeData;
  }
}