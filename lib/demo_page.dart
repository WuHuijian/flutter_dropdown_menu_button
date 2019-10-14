import 'package:flutter/material.dart';
import 'w_dropdown_menu.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
 
  final List tabs = ['进行中', '已完成'];
 
  final List datas = [
    {'title': '选项一', 'value': 1},
    {'title': '选项二', 'value': 2},
    {'title': '选项三', 'value': 3},
    {'title': '选项四', 'value': 4},
    {'title': '选项五', 'value': 5},
    {'title': '选项六', 'value': 6},
    {'title': '选项七', 'value': 7},
    {'title': '选项八', 'value': 8},
    {'title': '选项九', 'value': 9},
  ];

  final Color _bgColor = Color.fromRGBO(83, 94, 104, 1);
  String typeName = '选项一';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HJDropdownMenuButton(
          top: kToolbarHeight+44, //放在appBar固定高度下方
          initialValue: 1,
          items: datas.map((e) {
            return HJPopupMenuItemData(title: e['title'], value: e['value']);
          }).toList(),
          valueChanged: (itemData) {
            setState(() {
              typeName = itemData.title;
            });
          },
        ),
        centerTitle: true,
        backgroundColor: _bgColor
      ),
      body: Container(color: Colors.white, child: Center(child: Text(typeName))),
    );
  }
}
