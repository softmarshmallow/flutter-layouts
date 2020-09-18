import 'package:flutter/material.dart';
import 'package:flutter_layouts/flutter_layouts.dart';

class BottomStickyScreen extends StatefulWidget {
  static const routeName = "/demo/sticky-footer";

  @override
  State<StatefulWidget> createState() => _BottomStickyScreenState();
}

class _BottomStickyScreenState extends State<BottomStickyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sticky bottom"),
      ),
      body: BottomSticky(
        body: ListView.builder(
          itemBuilder: (c, i) {
            return Text("body");
          },
          itemCount: 50,
        ),
        bottom: FlatButton(
          onPressed: () {},
          child: Text("press me"),
        ),
//        bottomSize: 100,
      ),
    );
  }
}
