///路由拦截器
abstract class RouteInterceptor {
  ///对于包含的路径进行过滤
  List<String> includeInterceptRoutes = [];

  RouteInterceptorResult addInterceptor(
      String path, Map<String, dynamic>? parameter);

  ///是否使用包含路径模式进行过滤
  bool get isUseIncludeMode => true;
}

class RouteInterceptorResult {
  ///是否拦截
  late bool isIntercepted;

  ///拦截后跳转的新地址
  late String redirectPath;

  ///拦截后跳转携带的参数
  Map<String, dynamic>? parameter;

  RouteInterceptorResult(
      {this.isIntercepted = false, this.redirectPath = "", this.parameter});
}
