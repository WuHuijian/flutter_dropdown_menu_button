import 'package:flutter/material.dart';
import 'package:flutter_dropdown_menu_button/demo_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '自定义下拉菜单',
      home: DemoPage(),
    );
  }
}