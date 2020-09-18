import 'package:flutter/material.dart';
import 'package:flutter_layouts_example/screens/bottom_sticky_screen.dart';
import 'package:flutter_layouts_example/screens/footer_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        FooterScreen.routeName: (c) => FooterScreen(),
        BottomStickyScreen.routeName: (c) => BottomStickyScreen(),
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (c, i) {
          var demo = demos[i];
          return ListTile(
            title: Text(demo.name),
            onTap: () {
              Navigator.of(context).pushNamed(demo.route);
            },
          );
        },
        itemCount: demos.length,
      ),
    );
  }
}
//  FooterScreen

class DemoScreenData {
  final String route;
  final String name;

  const DemoScreenData({@required this.route, @required this.name});
}

final List<DemoScreenData> demos = [
  const DemoScreenData(route: FooterScreen.routeName, name: "footer"),
  const DemoScreenData(
      route: BottomStickyScreen.routeName, name: "sticky-bottom"),
];
