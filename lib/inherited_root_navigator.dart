import 'package:flutter/cupertino.dart';

import 'delegate/reactive_router_delegate.dart';

///
/// * @ProjectName: flutter_routekit
/// * @Author: qifanxin
/// * @CreateDate: 2022/7/18 15:29
/// * @Description: 文件说明
///

class InheritedRootNavigator extends InheritedWidget {
  /// Default constructor for the inherited go router.
  const InheritedRootNavigator({
    required Widget child,
    required this.delegate,
    Key? key,
  }) : super(child: child, key: key);

  final ReactiveRouterDelegate delegate;

  /// Used by the Router architecture as part of the InheritedWidget.
  @override
  bool updateShouldNotify(covariant InheritedRootNavigator oldWidget) {
    // avoid rebuilding the widget tree if the router has not changed
    return delegate != oldWidget.delegate;
  }
}
