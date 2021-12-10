

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reactive_router/delegate/reactive_router_delegate.dart';

class MainPage extends StatefulWidget {

  const MainPage({ Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    print("init1");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("1");
    return Scaffold(
      appBar: AppBar(title: Text("main")),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            ReactiveRouterDelegate.of(context).push("/a", clearStack: true);
          },
          child: Text("点击"),
        ),
      ),
    );
  }

}