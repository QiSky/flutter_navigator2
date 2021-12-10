

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reactive_router/delegate/reactive_router_delegate.dart';

class NTFoundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();

}

class _MainPageState extends State<NTFoundPage> {

  @override
  void initState() {
    print("init3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("3");
    return Scaffold(
      appBar: AppBar(title: Text("啥玩意"),
      leading: IconButton(onPressed: () {
        ReactiveRouterDelegate.of(context).popRoute();
      }, icon: Icon(CupertinoIcons.back),),),
      body: Center(
        child: Text("卧槽，找不到了"),
      ),
    );
  }

}