import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_router/annotation/page_annotation.dart';
import 'package:reactive_router/delegate/reactive_router_delegate.dart';

@PageAnnotation(name: 'main', path: '/')
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

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
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //上层 widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    print("didChangeDependencies");
  }

  @override
  Widget build(BuildContext context) {
    print("1");
    return Scaffold(
      appBar: AppBar(title: Text("main")),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            ReactiveRouterDelegate.of(context).push("/a").then((value) {
              print(value);
            });
          },
          child: Text("点击"),
        ),
      ),
    );
  }
}
