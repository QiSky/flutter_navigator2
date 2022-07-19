import 'package:flutter/material.dart';
import 'package:reactive_router/delegate/reactive_router_delegate.dart';
import 'package:reactive_router/parser/reactive_router_parser.dart';
import 'package:reactive_router_example/pages/404_page.dart';
import 'package:reactive_router_example/pages/index_page.dart';
import 'package:reactive_router_example/pages/main_page.dart';

void main() {
  ReactiveRouterDelegate.instance
      .init((arguments, {Key? key}) => NTFoundPage());
  ReactiveRouterDelegate.instance.addRouteMap("/",
      handler: (Map<String, dynamic>? arguments) {
    return const MainPage();
  });
  ReactiveRouterDelegate.instance.addRouteMap("/a",
      handler: (Map<String, dynamic>? arguments) {
    return const IndexPage();
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: ReactiveRouterDelegate.instance,
      routeInformationParser: ReactiveRouterParser(),
    );
  }
}
