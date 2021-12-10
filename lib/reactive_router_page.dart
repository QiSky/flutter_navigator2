import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReactiveRouterPage extends Page {

  /// args
  late Map<String,dynamic>? parameter;

  /// widgetBuilder
  late final WidgetHandler handler;

  Route? route;

  late Completer<dynamic> completer;

  ReactiveRouterPage({required LocalKey key, String? name, this.parameter, required this.handler, this.route})
  : super(name: name, arguments: parameter, key: key);

  @override
  Route createRoute(BuildContext context) {
    return route ?? CupertinoPageRoute(
        settings: this,
        builder: (BuildContext context) => handler.call(parameter));
  }

  ReactiveRouterPage clone() {
    return ReactiveRouterPage(key: ValueKey(name), name: name, parameter: parameter, handler: handler);
  }

  @override
  bool canUpdate(Page<dynamic> other) {
    return other.runtimeType == runtimeType &&
        other.key == key;
  }
}

typedef WidgetHandler = Widget Function(Map<String,dynamic>? arguments);