import 'package:common_utils/common_utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

class ExpandableText extends StatefulWidget {

  final String? text;
  final int? maxLines;
  final TextStyle? style;
  final TextOverflow overflow;

  ExpandableText({
    Key? key,
    this.text,
    this.maxLines,
    this.style,
    this.overflow = TextOverflow.ellipsis
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("ExpandableText: createState()");
    return _ExpandableTextState();
  }

}

class _ExpandableTextState extends State<ExpandableText> {

  int? get maxLines => widget.maxLines;
  String? get text => widget.text;
  TextStyle? get style => widget.style;
  TextOverflow? get overflow => widget.overflow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final span = TextSpan(text: text, style: style);
      final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr
      );
      tp.layout(maxWidth: size.maxWidth);

      if (tp.didExceedMaxLines) { // 判断文字是否溢出
        return ExpandableNotifier(
          child: Column(
              children: [
                Expandable(
                  collapsed: Column(
                      children: [
                        Text(text??"", maxLines: maxLines, overflow: overflow, style: style),
                        ExpandableButton(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('全文',
                                  style: TextStyle(
                                    color: ResourceColors.theme_background,
                                    fontSize: ScreenUtil.getInstance().getSp(12.0),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down, color: ResourceColors.theme_background,),
                              ],
                            ),
                        ),
                      ]
                  ),
                  expanded: Column(
                      children: [
                        Text(text??"", style: style),
                        ExpandableButton(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('收起',
                                style: TextStyle(
                                  color: ResourceColors.theme_background,
                                  fontSize: ScreenUtil.getInstance().getSp(12.0),
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_up, color: ResourceColors.theme_background,),
                            ],
                          ),
                        ),
                      ]
                  ),
                )
              ]
          ),
        );
      } else {
        return Text(text??"", style: style);
      }
    });
  }

}