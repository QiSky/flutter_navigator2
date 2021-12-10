import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:reactive_router/interceptor/route_interceptor.dart';
import 'package:reactive_router/reactive_router_page.dart';

class ReactiveRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  ///单例
  static ReactiveRouterDelegate get instance => _getInstance()!;
  static ReactiveRouterDelegate? _instance;

  static const NOT_FOUND_PATH = '/404';

  final key = GlobalKey<NavigatorState>();

  late WidgetHandler pageBuilder;

  List<RouteInterceptor> _interceptorList = [];

  static ReactiveRouterDelegate? _getInstance() {
    if (_instance == null) {
      _instance = ReactiveRouterDelegate();
    }
    return _instance;
  }

  void init(WidgetHandler notfoundPageBuilder) {
    _pageMap[NOT_FOUND_PATH] = ReactiveRouterPage(
        key: ValueKey(NOT_FOUND_PATH),
        name: NOT_FOUND_PATH,
        handler: notfoundPageBuilder);
  }

  ///路由栈维护列表
  List<String> _routeStack = [];

  ///仅可查看的路由栈(不可直接进行操作)
  List<String> get stack => List.unmodifiable(_routeStack);

  List<ReactiveRouterPage> _pageStack = [];

  ///页面映射表
  Map<String, ReactiveRouterPage> _pageMap = {};

  @override
  GlobalKey<NavigatorState>? get navigatorKey => key;

  ///根据context获取单例
  static ReactiveRouterDelegate of(BuildContext context) {
    assert(Router.of(context).routerDelegate is ReactiveRouterDelegate);
    return Router.of(context).routerDelegate as ReactiveRouterDelegate;
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
  }

  @override
  String? get currentConfiguration =>
      _routeStack.isNotEmpty ? _routeStack.last : null;

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey, onPopPage: _onPopPage, pages: _pageStack.toList());
  }

  ///跳转页面
  ///path: 跳转页面的地址
  ///parameter: 跳转携带的参数
  ///replace: 退出上一个页面且进入到新页面
  ///clearStack: 退出所有页面，进入新页面
  ///isSingleTop: 如新页面地址与当前页面地址一致，则退出当前页面，且进入新页面
  ///isSingleTask: 如路由栈中存在页面地址，则退出所有存在的地址，并将地址推到栈顶，
  ///generateRoute: 自定义过场动画效果
  Future push<T>(String path,
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
        _routeStack.removeLast();
        _pageStack.removeLast();
      }
      if (clearStack) {
        _routeStack.clear();
        _pageStack.clear();
      }
      if (isSingleTop) {
        if (_routeStack.last == path) {
          _routeStack.removeLast();
          _pageStack.removeLast();
        }
      }
      if (isSingleTask) {
        _routeStack.removeWhere((element) => element == path);
        _pageStack.removeWhere((element) => element.name == path);
      }
      _routeStack.add(path);
      var page = _pageMap[path]!.clone()..parameter = parameter;
      page..route = generateRoute?.call(page, _pageMap[path]?.handler)..completer = Completer();
      _pageStack.add(page);
      notifyListeners();
      return page.completer.future;
    } else {
      _routeStack.add(NOT_FOUND_PATH);
      _pageStack.add(_pageMap[NOT_FOUND_PATH]!.clone()..completer = Completer());
      notifyListeners();
      return Future.value();
    }
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (_routeStack.last == route.settings.name) {
      _routeStack.removeLast();
      _pageStack.removeLast();
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
      int index = _routeStack.lastIndexWhere((element) => element == untilName);
      if (index == -1) {
        return false;
      } else {
        _routeStack = _routeStack.sublist(0, index + 1);
        _pageStack = _pageStack.sublist(0, index + 1);
        return true;
      }
    } else {
      if (_routeStack.length > 1) {
        _pageStack.last.completer.complete(result);
        _routeStack.removeLast();
        _pageStack.removeLast();
        notifyListeners();
        return true;
      } else {
        _pageStack.last.completer.complete(result);
        return false;
      }
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    _routeStack
      ..clear()
      ..add(configuration);
    _pageStack
      ..clear()
      ..add(_pageMap[configuration] ??
          ReactiveRouterPage(
              key: ValueKey(NOT_FOUND_PATH),
              name: NOT_FOUND_PATH,
              handler: pageBuilder));
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  ReactiveRouterDelegate addInterceptor(RouteInterceptor routeInterceptor) {
    _interceptorList.add(routeInterceptor);
    return this;
  }

  ReactiveRouterDelegate addRouteMap(String path,
      {Map<String, dynamic>? parameter,
      required WidgetHandler handler,
      Route? Function(RouteSettings settings, WidgetHandler? handler)?
          generateRoute}) {
    var page =
        ReactiveRouterPage(key: ValueKey(path), name: path, handler: handler);
    page.route = generateRoute?.call(page, handler);
    _pageMap[path] = page;
    return this;
  }

  ReactiveRouterDelegate removeRouteMap(String path) {
    _pageMap.remove(path);
    return this;
  }
}
