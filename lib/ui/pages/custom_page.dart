import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:rxdart/subjects.dart';

class CustomView extends StatefulWidget{

  bool isToTop = false;
  double offset = 0.0;
  int toolbarColor = 0x002978FC;

  @override
  State<StatefulWidget> createState() {
    return CustomViewState();
  }
}

class CustomViewState extends State<CustomView> {
  //滚动控制器
  late ScrollController _controller;

  BehaviorSubject<bool> _floatingController = BehaviorSubject<bool>();
  BehaviorSubject<int> _colorController = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    LogUtil.e("CustomPageState: initState()");
    _controller = ScrollController(initialScrollOffset: widget.offset);
    _controller.addListener((){
      var alpha = 255.0;
      var toolBarHeight = Size.fromHeight(ScreenUtil.getInstance().statusBarHeight+kToolbarHeight).height;

      widget.offset = _controller.offset;
      alpha = (alpha * _controller.offset) / toolBarHeight;
      var resultAlpha = num.parse("$alpha").toInt();
      if(_controller.offset <= 100 && widget.isToTop){
        widget.isToTop = false;
        _floatingController.sink.add(false);
        if (resultAlpha <= 255) {
          resultAlpha = (resultAlpha << 24) | 0x00FFFFFF;
          widget.toolbarColor = resultAlpha & 0xFF2978FC;
        } else {
          widget.toolbarColor = 0xFF2978FC;
        }
        _colorController.sink.add(widget.toolbarColor);
      } else if(_controller.offset > 144 && !widget.isToTop){
        widget.isToTop = true;
        _floatingController.sink.add(true);
        widget.toolbarColor = 0xFF2978FC;
        _colorController.sink.add(widget.toolbarColor);
      } else if (resultAlpha <= 255) {
        resultAlpha = (resultAlpha << 24) | 0x00FFFFFF;
        widget.toolbarColor = resultAlpha & 0xFF2978FC;
        _colorController.sink.add(widget.toolbarColor);
      } else if (resultAlpha > 255 && widget.toolbarColor != 0xFF2978FC) {
        widget.toolbarColor = 0xFF2978FC;
        _colorController.sink.add(widget.toolbarColor);
      }
    });
    if (widget.offset > 0) {
      _colorController.sink.add(widget.toolbarColor);
      _floatingController.sink.add(widget.isToTop);
    }
  }

  void _onPressed() {
    //回到ListView顶部
    _controller.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("CustomPageState: build()");
    return Scaffold(
      backgroundColor:Colors.white,
//      appBar: AppBar(title: Text("CustomView AppBar Title")),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
//              SliverAppBar(
//                leading: Icon(Icons.arrow_back_ios),
////                automaticallyImplyLeading: false,
////            title: Text("视差滚动效果",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
//                floating: true,
//                flexibleSpace: FlexibleSpaceBar(
////                  centerTitle: true,
//                  title: Text("视差滚动效果",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
//                  background: Image.network(
//                      "http://img95.699pic.com/photo/50057/7197.jpg_wh300.jpg",
//                      fit:BoxFit.cover),
//                ),
////                flexibleSpace: Image.network(
////                    "http://img95.699pic.com/photo/50057/7197.jpg_wh300.jpg",
////                    fit:BoxFit.cover),
//                expandedHeight: 196,
//                pinned: true,
//                snap: true,
//              ),
              SliverAppBar(
//                leading: Icon(Icons.arrow_back),
                automaticallyImplyLeading: false,
//                title: Text("视差滚动效果",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
//                floating: true,
                flexibleSpace: Image.network(
                    "http://img95.699pic.com/photo/50057/7197.jpg_wh300.jpg",
                    fit:BoxFit.cover),
                expandedHeight: 196,
                backgroundColor: ResourceColors.theme_background,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context,index)=>ListTile(title: Text('Item $index')),
                  childCount:100,
                ),
              )
            ],
          ),
//          Container(
//            width: ScreenUtil.getInstance().screenWidthDp,
//            height: Size.fromHeight(ScreenUtil.getInstance().statusBarHeight+kToolbarHeight).height,
//            color: Color(toolbarColor),
//            child: Row(
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                Icon(Icons.arrow_back_ios),
//                Text("视差滚动效果",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold))
//              ],
//            ),
//          ),
          StreamBuilder<int>(
            stream: _colorController.stream,
            builder: (BuildContext ctx, AsyncSnapshot<int> snapshot) {
              return Container(
                width: ScreenUtil.getInstance().screenWidth,
                height: Size.fromHeight(ScreenUtil.getInstance().statusBarHeight+kToolbarHeight).height,
                color: (snapshot != null && snapshot.hasData) ? Color(snapshot.data??0x002978FC) : Color(0x002978FC),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: Size.fromHeight(ScreenUtil.getInstance().statusBarHeight).height,
                    ),
                    Container(
//                  width: ScreenUtil.getInstance().screenWidthDp,
                      height: Size.fromHeight(kToolbarHeight).height,
                      child: Row(
//                    mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
//                            child: Ink(
//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().getWidth(26))),
//                                  color: Colors.black12
//                              ),
//                              child: InkWell(
//                                borderRadius: BorderRadius.circular(ScreenUtil.getInstance().getWidth(26)),
//                                onTap: () {
//                                  Navigator.maybePop(context);
//                                },
//                                child: Container(
//                                  width: ScreenUtil.getInstance().getWidth(52),
//                                  alignment: Alignment.center,
//                                  child: Icon(Icons.arrow_back_ios, color: Colors.white),
//                                ),
//                              ),
//                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(ScreenUtil.getInstance().getWidth(26)),
                              onTap: () {
                                Navigator.maybePop(context);
                              },
                              child: Container(
                                width: ScreenUtil.getInstance().getWidth(52),
                                alignment: Alignment.center,
                                child: Icon(Icons.arrow_back_ios, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: ScreenUtil.getInstance().getWidth(52)),
                                child: Text(
                                    "视差滚动效果",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: _floatingController.stream,
        builder: (BuildContext ctx, AsyncSnapshot<bool> snapshot) {
          return (snapshot != null && snapshot.hasData && (snapshot.data??false)) ? FloatingActionButton(onPressed: ()=>_onPressed(), child:Icon(Icons.arrow_upward)) : Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _floatingController?.close();
    _controller.dispose();
    super.dispose();
  }
}