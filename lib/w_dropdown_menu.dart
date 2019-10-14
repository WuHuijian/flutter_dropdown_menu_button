import 'package:flutter/material.dart';

/// 菜单item显示数据
class HJPopupMenuItemData {
  String title;
  dynamic value;
  HJPopupMenuItemData({this.title, this.value});
}

/// 下拉菜单按钮
class HJDropdownMenuButton extends StatefulWidget {
  final double left; //距离左边位置
  final double top; //距离上面位置
  final dynamic initialValue; //默认值
  final List<HJPopupMenuItemData> items; //
  final Function valueChanged;

  HJDropdownMenuButton(
      {this.left, this.top, this.initialValue, this.items, this.valueChanged});

  @override
  _HJDropdownMenuButtonState createState() => _HJDropdownMenuButtonState();
}

class _HJDropdownMenuButtonState extends State<HJDropdownMenuButton> {
  bool isOpen = false;
  dynamic currentSelectValue;

  @override
  void initState() {
    currentSelectValue = widget.initialValue;
    super.initState();
  }

  // 设置菜单按钮打开状态
  void setOpenStatus() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  // 获取当前选中项名称
  String _buttonTitle() {
    String title;
    widget.items.forEach((e) {
      if (e.value == currentSelectValue) {
        title = e.title;
      }
    });
    return title;
  }

  // 选项改变回调
  void _valueChangedCallback(value) {
    int index = widget.items.indexWhere((e) => (e.value == value));
    if (widget.valueChanged != null) {
      widget.valueChanged(widget.items[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(_buttonTitle()),
        SizedBox(
          width: 5,
        ),
        Icon(
          (isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          size: 30,
        )
      ]),
      onTap: () {
        setOpenStatus();
        Navigator.push(
          context,
          HJPopupMenuRoute(
            child: HJPopupMenu(
              left: widget.left,
              top: widget.top,
              initialValue: currentSelectValue,
              items: widget.items,
              valueChanged: (value) {
                setState(() {
                  currentSelectValue = value;
                  _valueChangedCallback(value);
                });
              },
            ),
          ),
        ).then((value) {
          setOpenStatus();
        });
      },
    );
  }
}

/// 下拉菜单容器
class HJPopupMenu extends StatefulWidget {
  final double left; //距离左边位置
  final double top; //距离上面位置
  final dynamic initialValue; //默认值
  final List<HJPopupMenuItemData> items; //
  final Function valueChanged;

  HJPopupMenu(
      {this.left, this.top, this.initialValue, this.items, this.valueChanged});

  @override
  _HJPopupMenuState createState() => _HJPopupMenuState();
}

class _HJPopupMenuState extends State<HJPopupMenu>
    with TickerProviderStateMixin {
  dynamic currentSelectValue;
  Animation<double> animation;
  AnimationController controller;

  static const int ANMATION_DURATION = 250;
  static const double MENU_HEIGHT = 300.0;

  @override
  void initState() {
    currentSelectValue = widget.initialValue;
    setupShowAnimation();
    super.initState();
  }

  // 设置开始动画
  void setupShowAnimation() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: ANMATION_DURATION), vsync: this);
    animation = new Tween(begin: 0.0, end: MENU_HEIGHT).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  // 设置结束动画
  void setupStopAnimation(VoidCallback completeCallback) {
    controller = new AnimationController(
        duration: const Duration(milliseconds: ANMATION_DURATION), vsync: this);
    animation = new Tween(begin: MENU_HEIGHT, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.status == AnimationStatus.completed) {
            completeCallback();
          }
        });
      });
    controller.forward();
  }

  // 点击菜单选项
  void _menuItemClick(dynamic value) {
    setState(() {
      currentSelectValue = value;
      if (widget.valueChanged != null) {
        widget.valueChanged(currentSelectValue);
      }
      setupStopAnimation(() {
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: animation.value,
                color: Colors.red,
                child: ListView(
                  //禁用反弹效果 但可以滚动
                  padding: EdgeInsets.all(0),
                  primary: true,
                  physics: ClampingScrollPhysics(),
                  children: widget.items.map((e) {
                    return HJPopupMenuItem(
                      title: e.title,
                      value: e.value,
                      checked: currentSelectValue == e.value,
                      tapOn: (value) {
                        _menuItemClick(value);
                      },
                    );
                  }).toList(),
                ),
              ),
              left: widget.left,
              top: widget.top,
            ),
          ],
        ),
        onTap: () {
          //点击空白处
          setupStopAnimation(() {
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
/// 菜单选项
class HJPopupMenuItem extends StatefulWidget {
  final String title;
  final dynamic value;
  final Function tapOn;
  final bool checked;

  HJPopupMenuItem(
      {@required this.title, @required this.value, this.tapOn, this.checked});
  @override
  _HJPopupMenuItemState createState() => _HJPopupMenuItemState();
}

class _HJPopupMenuItemState extends State<HJPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Color.fromRGBO(83, 94, 104, 0.9),
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 16,
                    color: widget.checked ? Colors.white : Color(0xFF999999)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  (widget.checked ? Icons.check : null),
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          if (widget.tapOn != null) {
            widget.tapOn(widget.value);
          }
        });
  }
}



/// popup路由
class HJPopupMenuRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  HJPopupMenuRoute({@required this.child});

  @override
  Color get barrierColor => null;//背景色

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

// class Popup extends StatefulWidget {
//   final Function onClick; //点击child事件
//   final double left; //距离左边位置
//   final double top; //距离上面位置
//   final List<HJDropdownMenuItemData> itemDatas;

//   Popup({
//     this.itemDatas,
//     this.onClick,
//     this.left,
//     this.top,
//   });

//   @override
//   _PopupState createState() => _PopupState();
// }

// class _PopupState extends State<Popup> {
//   int currentSelectIndex = 0; //当前选中项

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: GestureDetector(
//         child: Stack(
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               color: Colors.transparent,
//             ),
//             Positioned(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 300,
//                 color: Colors.transparent,
//                 child: ListView.builder(
//                   itemCount: widget.itemDatas.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return GestureDetector(
//                         child: Container(
//                           alignment: Alignment.center,
//                           color: Color.fromRGBO(83, 94, 104, 0.9),
//                           height: 44,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               SizedBox(
//                                 width: 30,
//                               ),
//                               Text(
//                                 widget.itemDatas[index].title,
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     color: widget.itemDatas[index].isSelect
//                                         ? Colors.white
//                                         : Color(0xFF999999)),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 20),
//                                 child: Icon(
//                                   (widget.itemDatas[index].isSelect
//                                       ? Icons.check
//                                       : null),
//                                   color: Colors.white,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             currentSelectIndex = index;
//                           });
//                         });
//                   },
//                 ),
//               ),
//               left: widget.left,
//               top: widget.top,
//             ),
//           ],
//         ),
//         onTap: () {
//           //点击空白处
//           Navigator.of(context).pop();
//         },
//       ),
//     );
//   }
// }
