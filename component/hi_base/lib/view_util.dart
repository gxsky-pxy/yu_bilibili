import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/format_util.dart';

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

//带文字的小图标
smallIconText(IconData iconData, var text) {
  var style = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text(
      '$text',
      style: style,
    )
  ];
}

//border线
borderLine(BuildContext context,{bottom:true,top:false}){
  BorderSide borderSide = BorderSide(width: 0.5,color: Colors.grey);
  return Border(
    bottom: bottom?borderSide:BorderSide.none,
    top: top?borderSide:BorderSide.none
  );
}

///间距
SizedBox hiSpace({double height: 1, double width: 1}) {
  return SizedBox(height: height, width: width);
}
