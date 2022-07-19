import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:reactive_router/inherited_root_navigator.dart';
import 'package:reactive_router/interceptor/route_interceptor.dart';
import 'package:reactive_router/reactive_router_page.dart';

class ReactiveRouterDelegate extends RouterDelegate<RouterMatch>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouterMatch> {
  ///单例
  static ReactiveRouterDelegate get instance => _getInstance()!;
  static ReactiveRouterDelegate? _instance;

  static const NOT_FOUND_PATH = '/404';

  late WidgetHandler pageBuilder;

  List<RouteInterceptor> _interceptorList = [];

  static ReactiveRouterDelegate? _getInstance() {
    _instance ??= ReactiveRouterDelegate();
    return _instance;
  }

  void init(String name, WidgetHandler pageBuilder) {
    _pageMap[NOT_FOUND_PATH] =
        RouterMatch(name: name, handler: pageBuilder, path: NOT_FOUND_PATH);
  }

  ///仅可查看的路由栈(不可直接进行操作)
  List<RouterMatch> get stack => List.unmodifiable(_pageStack);

  List<RouterMatch> _pageStack = <RouterMatch>[];

  final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();

  ///页面映射表
  Map<String, RouterMatch> _pageMap = {};

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  static ReactiveRouterDelegate of(BuildContext context) {
    final InheritedRootNavigator? inherited =
        context.dependOnInheritedWidgetOfExactType<InheritedRootNavigator>();
    return inherited!.delegate;
  }

  @override
  RouterMatch? get currentConfiguration =>
      _pageStack.isNotEmpty ? _pageStack.last : null;

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> pages = [];
    _pageStack.forEach((e) {
      var key = ValueKey<String>(e.path!);
      pages.add(CupertinoPage(
          key: key,
          child: e.handler!.call(e.parameter),
          name: e.path,
          arguments: e.parameter ?? {},
          restorationId: key.value));
    });
    return InheritedRootNavigator(
        child: Navigator(key: _key, onPopPage: _onPopPage, pages: pages),
        delegate: this);
  }

  ///跳转页面
  ///path: 跳转页面的地址
  ///parameter: 跳转携带的参数
  ///replace: 退出上一个页面且进入到新页面
  ///clearStack: 退出所有页面，进入新页面
  ///isSingleTop: 如新页面地址与当前页面地址一致，则退出当前页面，且进入新页面
  ///isSingleTask: 如路由栈中存在页面地址，则退出所有存在的地址，并将地址推到栈顶，
  ///generateRoute: 自定义过场动画效果
  Future? push<T>(String path,
      {Map<String, dynamic>? parameter,
      bool replace = false,
      bool clearStack = false,
      bool isSingleTop = false,
      bool isSingleTask = false,
      Route? Function(RouteSettings settings, WidgetHandler? handler)?
          generateRoute}) {
    if (_pageMap.containsKey(path)) {
      ///如果拦截器不为空，则对于跳转的页面进行过滤
      if (_interceptorList.isNotEmpty) {
        for (var i = 0; i < _interceptorList.length; i++) {
          var res = _interceptorList[i].addInterceptor(path, parameter);

          ///如果跳转动作被拦截，则指向新路由
          if (res.isIntercepted) {
            path = res.redirectPath;
            parameter = res.parameter;
            break;
          }
        }
      }
      if (replace) {
        _pageStack.removeLast();
      }
      if (clearStack) {
        _pageStack.clear();
      }
      if (isSingleTop) {
        if (_pageStack.last.path == path) {
          _pageStack.removeLast();
        }
      }
      if (isSingleTask) {
        _pageStack
            .removeWhere((element) => element.route?.settings.name == path);
      }
      var page = _pageMap[path]?.clone(path: path, parameter: parameter);
      _pageStack.add(page!);
      notifyListeners();
      return page.route?.popped;
    } else {
      _pageStack.add(_pageMap[NOT_FOUND_PATH]!.clone());
      notifyListeners();
      return Future.value();
    }
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_pageStack.last.path == route.settings.name) {
      _pageStack.removeLast();
      notifyListeners();
      return route.didPop(result);
    } else {
      return false;
    }
  }

  ///回退页面
  ///isUnitl: 是否回退至指定页面
  ///untilName: 回退到指定页面的页面名
  ///result: 页面回退时携带的结果
  bool pop<T>({bool isUntil = false, String? untilName, T? result}) {
    if (isUntil) {
      int index =
          _pageStack.lastIndexWhere((element) => element.path == untilName);
      if (index == -1) {
        return false;
      } else {
        _pageStack = _pageStack.sublist(0, index + 1);
        return true;
      }
    } else {
      if (_pageStack.length > 1) {
        var route = _pageStack.last.route;
        _pageStack.removeLast();
        notifyListeners();
        return route!.didPop(result);
      } else {
        return false;
      }
    }
  }

  @override
  Future<void> setNewRoutePath(RouterMatch? configuration) {
    _pageStack
      ..clear()
      ..add(configuration!);
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setInitialRoutePath(RouterMatch? configuration) {
    return setNewRoutePath(configuration);
  }

  ReactiveRouterDelegate addInterceptor(RouteInterceptor routeInterceptor) {
    _interceptorList.add(routeInterceptor);
    return this;
  }

  ReactiveRouterDelegate addRouteMap(
      {required String name,
      required String path,
      required WidgetHandler handler}) {
    _pageMap[path] = RouterMatch(name: name, path: path, handler: handler);
    return this;
  }

  RouterMatch getMatch(String url) {
    return _pageMap[url]!;
  }

  ReactiveRouterDelegate removeRouteMap(String path) {
    _pageMap.remove(path);
    return this;
  }
}
