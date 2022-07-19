import 'package:flutter/cupertino.dart';

class RouterMatch {
  /// name
  String? path;

  /// args
  Map<String, dynamic>? parameter;

  /// widgetBuilder
  final WidgetHandler? handler;

  Route? route;

  RouterMatch({required this.path, this.parameter, this.handler}) {
    route = CupertinoPageRoute(
        settings: RouteSettings(name: path, arguments: parameter),
        builder: (BuildContext context) => handler!.call(parameter));
  }

  RouterMatch clone(
      {String? path, Map<String, dynamic>? parameter, WidgetHandler? handler}) {
    return RouterMatch(
        path: path ?? this.path,
        parameter: parameter ?? this.parameter,
        handler: handler ?? this.handler);
  }

  @override
  bool operator ==(Object other) => other is RouterMatch && other.path == path;

  @override
  int get hashCode => path.hashCode;
}

typedef WidgetHandler = Widget Function(Map<String, dynamic>? arguments);
