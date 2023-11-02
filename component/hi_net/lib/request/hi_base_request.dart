
enum HttpMethod { GET, POST, DELETE }

//基础请求
abstract class HiBaseRequest {
  var pathParams;
  var useHttps = true;
  String authority() {
    return 'api.devio.org';
  }

  HttpMethod httpMethod();
  String path();//api请求路径
  String url() {
    Uri uri;
    var pathStr = path();
    //拼接path参数
    if (pathParams != null) {
      if (path().endsWith('/')) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    //http和https切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    return uri.toString();
  }

  bool needLogin();//该接口是否需要登录

  Map<String, String> params = Map();
  //添加参数
  HiBaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {};
  //添加header
  HiBaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
