import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? editController;
  final FocusNode? editFocusNode;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? textTextStyle;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final Color? decorationColor;
  final double? decorationRadius;

  const SearchBar({
    Key? key,
    this.editController,
    this.editFocusNode,
    this.hintText,
    this.hintTextStyle,
    this.textTextStyle,
    this.onChanged,
    this.onEditingComplete,
    this.decorationColor,
    this.decorationRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.e("SearchBar: build()");
    return Container(
      height: ScreenUtil.getInstance().getAdapterSize(44),
      decoration: BoxDecoration(
        color: decorationColor??Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(decorationRadius??6.0)),
        border: Border.all(color: ResourceColors.divider, width: 0.6),
      ),
      margin: EdgeInsets.fromLTRB(
        ScreenUtil.getInstance().getWidth(14.0),
        ScreenUtil.getInstance().getAdapterSize(10.0),
        ScreenUtil.getInstance().getWidth(14.0),
        ScreenUtil.getInstance().getAdapterSize(10.0),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: editController,
        focusNode: editFocusNode,
        textInputAction: TextInputAction.search,
        style: textTextStyle??TextStyle(fontSize: ScreenUtil.getInstance().getSp(14.0), color: ResourceColors.gray_33),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
//                    left: ScreenUtil.getInstance().getWidth(10.0),
            right: ScreenUtil.getInstance().getWidth(10.0),
          ),
          icon: Container(
            padding: EdgeInsets.only(top: 4.0, left: ScreenUtil.getInstance().getWidth(10.0),),
            child: Icon(Icons.search),
          ),
          border: InputBorder.none,
          hintText: hintText??'搜索',//ResourceUtils.getString(Ids.inputAccount),
          hintStyle: hintTextStyle??TextStyle(fontSize: ScreenUtil.getInstance().getSp(14.0)),
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}