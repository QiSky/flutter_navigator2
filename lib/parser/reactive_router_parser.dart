
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ReactiveRouterParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(routeInformation.location!);
  }

  @override
  RouteInformation restoreRouteInformation(Object configuration) {
    return RouteInformation(location: configuration.toString());
  }
}
