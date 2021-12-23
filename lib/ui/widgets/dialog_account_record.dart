import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/models/login_record_model.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';

class AccountRecordDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountRecordDialogState();
  }

}

class _AccountRecordDialogState extends State<AccountRecordDialog> {
  List<LoginRecordModel> _recordList = <LoginRecordModel>[];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      List<Map<String, dynamic>>? list = SpUtil.getObjectList("LoginRecord")?.cast<Map<String, dynamic>>();
      if (list != null && list.length > 0) {
        return list.map<LoginRecordModel>((value) {
          return LoginRecordModel.fromJson(value);
        }).toList();
      }
      return null;
    }).then((value) {
      if (value != null) {
        setState(() {
          _recordList.addAll(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil.getInstance().screenHeight / 3,
      child: ListView.separated(
        itemCount: _recordList.length,
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 0.8,
            color: ResourceColors.divider,
            margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(18.0),),
          );
        },
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.pop(context);
              } else {
                Navigator.pop(context, _recordList[index]);
              }
            },
            child: Container(
              width: double.infinity,
              height: ScreenUtil.getInstance().getAdapterSize(56.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _recordList[index].getTXID() == null || _recordList[index].getTXID() == 0 ? Container(
                    width: ScreenUtil.getInstance().getAdapterSize(40.0),
                    height: ScreenUtil.getInstance().getAdapterSize(40.0),
                    margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(18.0),),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(ScreenUtil.getInstance().getAdapterSize(40.0) / 2.0 - 0.5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(ResourceUtil.getResourceImage('icon_default')),
                      ),
                    ),
                  ) : Container(
                    width: ScreenUtil.getInstance().getAdapterSize(40.0),
                    height: ScreenUtil.getInstance().getAdapterSize(40.0),
                    margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(18.0),),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(ScreenUtil.getInstance().getAdapterSize(40.0) / 2.0 - 0.5),
                      child: CachedNetworkImage(
                        imageUrl: "", // image url
                        width: ScreenUtil.getInstance().getAdapterSize(40.0),
                        height: ScreenUtil.getInstance().getAdapterSize(40.0),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                        errorWidget: (context, url, error) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().getAdapterSize(10.0),
                        right: ScreenUtil.getInstance().getAdapterSize(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((_recordList[index].getUserName())?? "",
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().getSp(15.0),
                              color: ResourceColors.gray_33,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text((_recordList[index].getUserAccount())??"",
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().getSp(13.0),
                              color: ResourceColors.gray_99,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  index == 0 ? Container(
                    margin: EdgeInsets.only(
                      right: ScreenUtil.getInstance().getAdapterSize(18.0),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ) : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}