import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_router/delegate/reactive_router_delegate.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();

  const IndexPage({Key? key, Map<String, dynamic>? arguments})
      : super(key: key);
}

class _MainPageState extends State<IndexPage> {
  @override
  void initState() {
    print("init2");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("2");
    return Scaffold(
      appBar: AppBar(title: Text("index")),
      body: Center(
        child: CupertinoButton(
          onPressed: () {
            ReactiveRouterDelegate.of(context).pop(result: 'a');
            // ReactiveRouterDelegate.of(context).push("/b");
          },
          child: Text("点击"),
        ),
      ),
    );
  }
}
