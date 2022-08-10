import 'package:yu_bilibili/http/core/hi_net.dart';
import 'package:yu_bilibili/http/request/profile_request.dart';
import 'package:yu_bilibili/model/profile_mo.dart';

class ProfileDao {
  static get() async{
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return ProfileMo.fromJson(result['data']);
  }
}