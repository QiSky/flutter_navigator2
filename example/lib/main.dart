import 'package:flutter/material.dart';
import 'package:reactive_router/delegate/reactive_router_delegate.dart';
import 'package:reactive_router/parser/reactive_router_parser.dart';
import 'package:reactive_router_example/pages/404_page.dart';
import 'package:reactive_router_example/pages/index_page.dart';
import 'package:reactive_router_example/pages/main_page.dart';
void main() {
  ReactiveRouterDelegate.instance.init((arguments) => NTFoundPage());
  ReactiveRouterDelegate.instance.addRouteMap("/", handler: (Map<String,dynamic>? arguments) {
    return MainPage();
  });
  ReactiveRouterDelegate.instance.addRouteMap("/a", handler: (Map<String,dynamic>? arguments) {
    return IndexPage();
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: ReactiveRouterDelegate.instance,
      routeInformationParser: ReactiveRouterParser(),
    );
  }

}
