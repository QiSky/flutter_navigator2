///
/// * @ProjectName: flutter_routekit
/// * @Author: qifanxin
/// * @CreateDate: 2022/9/5 17:33
/// * @Description: 文件说明
///

abstract class RouteInterceptor {
  ///需要经过拦截的路由
  List<String> interceptRoutes = [];

  RouteInterceptorResult addInterceptor(
      String path, Map<String, dynamic>? arguments);
}

///拦截器结果
class RouteInterceptorResult {
  ///是否拦截
  final bool isIntercept;

  ///拦截后跳转的地址
  final String redirectPath;

  RouteInterceptorResult({this.isIntercept = false, this.redirectPath = ""});
}
