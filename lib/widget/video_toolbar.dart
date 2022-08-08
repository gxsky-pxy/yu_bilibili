import 'package:flutter/material.dart';
import 'package:yu_bilibili/model/video_detail_mo.dart';
import 'package:yu_bilibili/model/video_model.dart';
import 'package:yu_bilibili/util/color.dart';
import 'package:yu_bilibili/util/format_util.dart';
import 'package:yu_bilibili/util/view_util.dart';

///视频点赞分享收藏等工具栏
class VideoToolBar extends StatelessWidget {
  final VideoDetailMo? detailMo;
  final VideoModel videoModel;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolBar(
      {Key? key,
        this.detailMo,
        required this.videoModel,
        this.onLike,
        this.onUnLike,
        this.onCoin,
        this.onFavorite,
        this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded, videoModel.like,
              onClick: onLike, tint: detailMo?.isLike ?? false),
          _buildIconText(Icons.thumb_down_alt_rounded, '不喜欢',
              onClick: onUnLike),
          _buildIconText(Icons.monetization_on, videoModel.coin,
              onClick: onCoin),
          _buildIconText(Icons.grade_rounded, videoModel.favorite,
              onClick: onFavorite, tint: detailMo?.isFavorite ?? false),
          _buildIconText(Icons.share_rounded, videoModel.share,
              onClick: onShare),
        ],
      ),
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      //显示格式化
      text = countFormat(text);
    } else if (text == null) {
      text = '';
    }
    tint = tint == null ? false : tint;
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Icon(
            iconData,
            color: tint ? primaryColor : Colors.grey,
            size: 20,
          ),
          hiSpace(height: 5),
          Text(text, style: TextStyle(color: Colors.grey, fontSize: 12))
        ],
      ),
    );
  }
}