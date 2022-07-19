import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:reactive_router/reactive_router_page.dart';

import '../delegate/reactive_router_delegate.dart';

class ReactiveRouterParser extends RouteInformationParser<RouterMatch> {
  @override
  Future<RouterMatch> parseRouteInformation(RouteInformation routeInformation) {
    return SynchronousFuture(
        ReactiveRouterDelegate.instance.getMatch(routeInformation.location!));
  }

  @override
  RouteInformation restoreRouteInformation(Object configuration) {
    return RouteInformation(location: configuration.toString());
  }
}
