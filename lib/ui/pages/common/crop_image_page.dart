import 'dart:async';
import 'dart:io';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropImagePage extends StatelessWidget {
  File sourceImageFile;
  final cropKey = GlobalKey<CropState>();
  File? _lastCropped;
  StreamSubscription<File?>? _streamSubscription;

  CropImagePage(this.sourceImageFile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            child: Crop(
              key: cropKey,
              image: FileImage(sourceImageFile),
              aspectRatio: 1.0,//4.0 / 3.0,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil.getInstance().getAdapterSize(18.0),
              right: ScreenUtil.getInstance().getAdapterSize(18.0),
              bottom: ScreenUtil.getInstance().getAdapterSize(30.0),
            ),
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _streamSubscription?.cancel();
                    _streamSubscription = null;
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().getAdapterSize(8.0),
                      right: ScreenUtil.getInstance().getAdapterSize(8.0),
                      top: ScreenUtil.getInstance().getAdapterSize(8.0),
                      bottom: ScreenUtil.getInstance().getAdapterSize(8.0),
                    ),
                    child: Text("取消",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil.getInstance().getSp(16.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_isCroping) {
                      return;
                    }
                    _isCroping = true;
                    _streamSubscription = Stream.fromFuture(_crop()).listen((event) {
                      _isCroping = false;
                      if (event != null) {
                        Navigator.pop(context, event);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().getAdapterSize(16.0),
                      right: ScreenUtil.getInstance().getAdapterSize(16.0),
                      top: ScreenUtil.getInstance().getAdapterSize(6.0),
                      bottom: ScreenUtil.getInstance().getAdapterSize(6.0),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Text("确定",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil.getInstance().getSp(15.0),
                        fontWeight: FontWeight.w600,
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

  bool _isCroping = false;
  Future<File?> _crop() async {
    double? scale = cropKey.currentState?.scale;
    final Rect? area = cropKey.currentState?.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return null;
    }
    if (scale == null) {
      scale = 1.0;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    File? _sample = await ImageCrop.sampleImage(
      file: sourceImageFile,
      preferredSize: (2000 / scale).round(),
    );
    _lastCropped?.deleteSync();
    _lastCropped = await ImageCrop.cropImage(
      file: _sample,
      area: area,
    );
    _sample.deleteSync();

    return _lastCropped;
  }
}