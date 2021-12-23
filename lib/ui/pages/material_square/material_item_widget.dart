import 'package:cached_network_image/cached_network_image.dart';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/models/response_model/material_response.dart';
import 'package:flutter_demo_app/network/api/file_api.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/base/task_controller_state.dart';
import 'package:flutter_demo_app/ui/widgets/circular_progress_bar.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';

import 'material_square_page.dart';

class MaterialItemWidget extends StatefulWidget {
  TabType type;
  MaterialsBean data;

  MaterialItemWidget(this.type, this.data);

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("MaterialItemWidget: createState()");
    return _MaterialItemWidgetState();
  }

}

class _MaterialItemWidgetState extends TaskControllerState<MaterialItemWidget> {

  @override
  void initState() {
    super.initState();
    LogUtil.e("_MaterialItemWidgetState: initState()");
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_MaterialItemWidgetState: build()");
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.data.avatarId == null || widget.data.avatarId == 0 ? Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil.getInstance().getAdapterSize(14.0),
                  left: ScreenUtil.getInstance().getAdapterSize(18.0),
                ),
                width: ScreenUtil.getInstance().getWidth(50.0),
                height: ScreenUtil.getInstance().getWidth(50.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
//                            shape: BoxShape.circle,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(ResourceUtil.getResourceImage('icon_default')),
                  ),
                ),
              ) : Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil.getInstance().getAdapterSize(14.0),
                  left: ScreenUtil.getInstance().getAdapterSize(18.0),
                ),
                width: ScreenUtil.getInstance().getWidth(50.0),
                height: ScreenUtil.getInstance().getWidth(50.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: CachedNetworkImage(
                    imageUrl: FileApi.getFileUrl(widget.data.avatarId??-1),
                    width: ScreenUtil.getInstance().getWidth(50.0),
                    height: ScreenUtil.getInstance().getWidth(50.0),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                    errorWidget: (context, url, error) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().getAdapterSize(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          widget.type == TabType.MY ? Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil.getInstance().getAdapterSize(10.0),
                              right: ScreenUtil.getInstance().getAdapterSize(18.0),
                              bottom: ScreenUtil.getInstance().getAdapterSize(4.0),
                            ),
                            child: Container(
                              child: Text(widget.data.createName??"",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().getSp(15),
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            ),
                          ) : Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil.getInstance().getAdapterSize(10.0),
                              right: ScreenUtil.getInstance().getAdapterSize(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text(widget.data.createName??"",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().getSp(15),
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().getAdapterSize(8.0))),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil.getInstance().getAdapterSize(8.0),
                                      right: ScreenUtil.getInstance().getAdapterSize(8.0),
                                      top: ScreenUtil.getInstance().getAdapterSize(4.0),
                                      bottom: ScreenUtil.getInstance().getAdapterSize(4.0),
                                    ),
                                    child: (widget.data.isCollect??false) ? Icon(Icons.star, color: Colors.redAccent,) : Icon(Icons.star_border, color: ResourceColors.gray_99,),
                                  ),
                                  onTap: () {

                                  },
                                ),
                              ],
                            ),
                          ),
                          (widget.data.labels != null && widget.data.labels!.length > 0) ? Container(
                            margin: EdgeInsets.only(
                              right: ScreenUtil.getInstance().getWidth(18.0),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: _buildLabelViews(widget.data.labels),
                              ),
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                    widget.data.SHZT != null && widget.data.SHZT!.compareTo("0") == 0 ? Container(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil.getInstance().getAdapterSize(14.0),
                          right: ScreenUtil.getInstance().getWidth(18.0),
                        ),
                        width: ScreenUtil.getInstance().getAdapterSize(69.0),
                        height: ScreenUtil.getInstance().getAdapterSize(50.0),
                        alignment: Alignment.topRight,
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage(ResourceUtil.getResourceImage('icon_checking')),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil.getInstance().getAdapterSize(8.0),
              right: ScreenUtil.getInstance().getWidth(18.0),
              left: ScreenUtil.getInstance().getAdapterSize(18.0),
            ),
            child: InkWell(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: widget.data.SCWA??""));
                ToastUtil.showToast("已复制");
              },
              child: Text(widget.data.SCWA??"",
                style: TextStyle(
                  fontSize: ScreenUtil.getInstance().getSp(13.0),
                  color: ResourceColors.gray_33,
                ),
              ),
            ),
          ),
          widget.data.files != null &&  widget.data.files!.length > 0 ? Container(
            margin: EdgeInsets.only(
              top: ScreenUtil.getInstance().getAdapterSize(10.0),
              left: ScreenUtil.getInstance().getAdapterSize(18.0),
              right: ScreenUtil.getInstance().getWidth(18.0),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
              physics: NeverScrollableScrollPhysics(),//禁用滑动事件
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // 横轴元素个数
                  crossAxisCount: 3,
                  //纵轴间距
                  mainAxisSpacing: ScreenUtil.getInstance().getWidth(10.0),
                  //横轴间距
                  crossAxisSpacing: ScreenUtil.getInstance().getWidth(10.0),
                  //子组件宽高长度比例
                  childAspectRatio: 1.0
              ),
              itemCount: widget.data.files != null ? widget.data.files!.length : 0,
              itemBuilder: (context, position) {
                return InkWell(
                  onTap: () {

                  },
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: FileApi.getFileUrl(widget.data.files![position]),
                    placeholder: (context, url) => Center(
                      child: CircularProgressBar(
                        width: ScreenUtil.getInstance().getAdapterSize(20.0),
                        height: ScreenUtil.getInstance().getAdapterSize(20.0),
                        accentColor: Theme.of(context).accentColor,
                        strokeWidth: 2.0,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.photo),
                    ),
                  ),
                );
              },
            ),
          ) : Container(),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil.getInstance().getAdapterSize(8.0),
              left: ScreenUtil.getInstance().getAdapterSize(18.0),
              right: ScreenUtil.getInstance().getWidth(18.0),
            ),
            child: Text(widget.data.CJSJ != null ? DateUtil.formatDate(DateUtil.getDateTimeByMs(widget.data.CJSJ!.toInt()), format: DateFormats.mo_d_h_m) : "--",
              style: TextStyle(
                fontSize: ScreenUtil.getInstance().getSp(12.0),
                color: ResourceColors.gray_66,
              ),
            ),
          ),
          Container(
//            margin: EdgeInsets.only(
//              top: ScreenUtil.getInstance().getAdapterSize(12.0),
//            ),
            width: double.infinity,
//                    color: ResourceColors.divider,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {

                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: ScreenUtil.getInstance().getAdapterSize(10.0),
                        bottom: ScreenUtil.getInstance().getAdapterSize(10.0),
                        left: ScreenUtil.getInstance().getWidth(4.0),
                        right: ScreenUtil.getInstance().getWidth(4.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up,
                            color: (widget.data.isLike??false) ? Colors.redAccent : ResourceColors.gray_66,
                            size: ScreenUtil.getInstance().getSp(16.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil.getInstance().getAdapterSize(4.0),
                            ),
                            child: Text('点赞 (${widget.data.likes})',
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(12.0),
                                color: (widget.data.isLike??false) ? Colors.redAccent : ResourceColors.gray_66,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 0.6,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {

                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: ScreenUtil.getInstance().getAdapterSize(10.0),
                        bottom: ScreenUtil.getInstance().getAdapterSize(10.0),
                        left: ScreenUtil.getInstance().getWidth(4.0),
                        right: ScreenUtil.getInstance().getWidth(4.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment,
                            color: ResourceColors.gray_66,
                            size: ScreenUtil.getInstance().getSp(16.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil.getInstance().getAdapterSize(4.0),
                            ),
                            child: Text('评论 (${widget.data.comments})',
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(12.0),
                                color: ResourceColors.gray_66,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               Container(
                 width: 0.6,
               ),
               Expanded(
                 child: InkWell(
                   onTap: () {

                   },
                   child: Container(
                     color: Colors.white,
                     padding: EdgeInsets.only(
                       top: ScreenUtil.getInstance().getAdapterSize(10.0),
                       bottom: ScreenUtil.getInstance().getAdapterSize(10.0),
                       left: ScreenUtil.getInstance().getWidth(4.0),
                       right: ScreenUtil.getInstance().getWidth(4.0),
                     ),
                     child: Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.share,
                           color: ResourceColors.gray_66,
                           size: ScreenUtil.getInstance().getSp(16.0),
                         ),
                         Container(
                           margin: EdgeInsets.only(
                             left: ScreenUtil.getInstance().getAdapterSize(4.0),
                           ),
                           child: Text('分享',// (${widget.data.forwards})
                             style: TextStyle(
                               fontSize: ScreenUtil.getInstance().getSp(12.0),
                               color: ResourceColors.gray_66,
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLabelViews(List<MeterialLabelsBean>? labels) {
    if (labels == null || labels.length == 0) {
      return <Widget>[];
    }
    List<Widget> labelViews = <Widget>[];
    for (int index = 0; index < labels.length; index++) {
      MeterialLabelsBean label = labels[index];
      Widget itemView = Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(ResourceUtil.getColorFromHex(label.BQYS??"0xFF2978FC")), width: 0.6),
          color: Color(0x19FFFFFF & ResourceUtil.getColorFromHex(label.BQYS??"0xFF2978FC")),
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
        ),
        padding: EdgeInsets.only(
          top: ScreenUtil.getInstance().getAdapterSize(1.0),
          left: ScreenUtil.getInstance().getAdapterSize(3.0),
          right: ScreenUtil.getInstance().getWidth(3.0),
          bottom: ScreenUtil.getInstance().getAdapterSize(1.0),
        ),
        child: Text((label.BQMC)??"",
          style: TextStyle(
            color: Color(ResourceUtil.getColorFromHex(label.BQYS??"0xFF2978FC")),
            fontSize: ScreenUtil.getInstance().getSp(10.0),
          ),
        ),
      );
      labelViews.add(itemView);
      if (index != (labels.length - 1)) {
        labelViews.add(Container(
          width: ScreenUtil.getInstance().getAdapterSize(6.0),
          height: ScreenUtil.getInstance().getAdapterSize(4.0),
        ));
      }
    }
    return labelViews;
  }
}