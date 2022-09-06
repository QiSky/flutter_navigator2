import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

///
/// * @ProjectName: flutter_routekit
/// * @Author: qifanxin
/// * @CreateDate: 2022/9/5 16:56
/// * @Description: 文件说明
///

class ReactiveRouterDelegate {
  late final GoRouter _goRoute;

  ///单例
  static ReactiveRouterDelegate get instance => _getInstance();
  static ReactiveRouterDelegate? _instance;

  static ReactiveRouterDelegate _getInstance() {
    _instance ??= ReactiveRouterDelegate();
    return _instance!;
  }

  RouteInformationParser get parser => _goRoute.routeInformationParser;

  RouteInformationProvider get provider => _goRoute.routeInformationProvider;

  RouterDelegate get delegate => _goRoute.routerDelegate;

  void init(
      {required List<GoRoute> routes, GoRouterPageBuilder? errorBuilder}) {
    _goRoute = GoRouter(routes: routes, errorPageBuilder: errorBuilder);
  }
}
