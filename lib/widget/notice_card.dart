import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/format_util.dart';
import 'package:hi_base/view_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yu_bilibili/model/home_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/navigator/hi_navigator.dart';

class NoticeCard extends StatelessWidget {
  final BannerMo notices;
  const NoticeCard({Key? key, required this.notices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _handleClick(notices);
      },
      child: Container(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 10),
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(),
            hiSpace(width: 10),
            _buildContent()
          ],
        ),
      ),
    );
  }

  _buildIcon() {
    var iconData = notices.type == 'video'
        ? Icons.ondemand_video_outlined
        :Icons.card_giftcard;
    return Icon(
      iconData,
      size: 30,
    );
  }

  _buildContent() {
    return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(
                  notices.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  dateMonthAndDay(notices.createTime),
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
            hiSpace(height: 5),
            Text(
                notices.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                )),
          ],
        ));
  }

  _handleClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
          args: {'videoMo': VideoModel(vid: bannerMo.url)});
    } else {
      print('type:${bannerMo.type} ,url:${bannerMo.url}');

       Uri _url = Uri.parse(bannerMo.url);
       _launchUrl(_url);
    }
  }

  Future <void> _launchUrl(Uri url) async{
    if (!await launchUrl(url)) {
    throw 'Could not launch $url';
    }
  }
}

