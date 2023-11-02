import 'package:hi_net/hi_net.dart';
import 'package:yu_bilibili/http/request/ranking_request.dart';
import 'package:yu_bilibili/model/ranking_mo.dart';

class RankingDao {
  static get(String sort, {int pageIndex = 1, pageSize: 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add('sort', sort)
        .add("pageSize", pageSize)
        .add("pageIndex", pageIndex);
    var result = await HiNet.getInstance().fire(request);
    print('sort是 $sort');
    return RankingMo.fromJson(result["data"]);
  }
}
