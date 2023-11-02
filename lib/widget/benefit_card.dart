import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yu_bilibili/model/profile_mo.dart';
import 'package:yu_bilibili/util/toast.dart';
import 'package:yu_bilibili/widget/hi_blur.dart';

///我的-增值服务
class BenefitCard extends StatelessWidget {
  final List<Benefit> benefitList;
  const BenefitCard({Key? key, required this.benefitList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [_buildTitle(), _buildBenefit(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '增值服务',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          hiSpace(width: 10),
          Text(
            '购买后登录慕课点击查看',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  _buildBenefit(BuildContext context) {
//根据卡片数量计算出每个卡片的宽度
    var width = (MediaQuery.of(context).size.width -
        20 -
        (benefitList.length - 1) * 5) /
        benefitList.length;
    return Row(
      children: [
        ...benefitList.map((e) => _buildCard(context, e, width)).toSet()
      ],
    );
  }

  _buildCard(BuildContext context, Benefit mo, double width) {
    return InkWell(
      onTap: () {
        if(mo.url.contains('http')){
          Uri _url = Uri.parse(mo.url);
          _launchUrl(_url);
        }else {
          FlutterClipboard.copy(mo.url).then(( value ) => showToast('群号已复制'));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: 60,
            decoration: BoxDecoration(color: Colors.redAccent),
            child: Stack(
              children: [
                Positioned.fill(child: HiBlur()),
                Positioned.fill(
                    child: Center(
                        child: Text(mo.name,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center)))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future <void> _launchUrl(Uri url) async{
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
