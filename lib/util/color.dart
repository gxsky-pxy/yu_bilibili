import 'package:flutter/material.dart';

//自定义颜色值，类似Colors.blue的源码
//主颜色值是0xfffb7299,第二个参数是可选其他色值  调用方式Colors.blue[50]
const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

///主色调
const MaterialColor primaryColor = const MaterialColor(
  0xfffb7299,
  const <int, Color>{50: const Color(0xffff9db5)},
);

class HiColor{
  static const  Color red = Color(0xFFFF4759);
  static const  Color dark_red = Color(0xFFE03E4E);
  static const  Color dark_bg = Color(0xFF18191A);
}
