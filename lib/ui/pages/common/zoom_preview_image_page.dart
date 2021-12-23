import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/widgets/circular_progress_bar.dart';
import 'package:flutter_demo_app/ui/widgets/customer_app_bar.dart';
import 'package:photo_view/photo_view.dart';

enum ImageSourceType {
  AssetImage,
  FileImage,
  MemoryImage,
  NetworkImage,
}
class ZoomPreviewImagePage extends StatelessWidget {
  ImageSourceType type;
  dynamic imageSource;
  ZoomPreviewImagePage(this.type, this.imageSource);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerAppBar(
        backgroundColor: ResourceColors.theme_background,
        titleContent: '图片预览',
        automaticallyImplyLeading: true,
        onWillPop: () {
          Navigator.maybePop(context);
        },
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: _buildPhotoView(context),
      ),
    );
    // return Scaffold(
    //   appBar: CustomerAppBar(
    //     backgroundColor: ResourceColors.theme_background,
    //     titleContent: '图片预览',
    //     automaticallyImplyLeading: true,
    //     onWillPop: () {
    //       Navigator.pop(context);
    //       if (Platform.isAndroid) {
    //         SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    //           statusBarColor: Colors.transparent,
    //           systemNavigationBarColor: ResourceColors.gray_background,
    //         );
    //         SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    //       }
    //     },
    //   ),
    //   backgroundColor: Colors.black,
    //   body: Container(
    //       child: _buildPhotoView(context),
    //   ),
    // );
  }

  Widget _buildPhotoView(BuildContext context) {
    return PhotoView(
      imageProvider: _getImageProvider(imageSource),
      maxScale: 0.65,
      minScale: 0.25,
      loadingBuilder: (context, event) {
        return Center(
          child: CircularProgressBar(
            width: ScreenUtil.getInstance().getAdapterSize(30.0),
            height: ScreenUtil.getInstance().getAdapterSize(30.0),
            accentColor: Theme.of(context).accentColor,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace,) {
        return Center(
          child: Icon(Icons.photo),
        );
      },
    );
  }

  ImageProvider? _getImageProvider(dynamic source) {
    if (type == ImageSourceType.AssetImage) {
      return AssetImage(source as String);
    }
    if (type == ImageSourceType.FileImage) {
      return FileImage(source as File);
    }
    if (type == ImageSourceType.MemoryImage) {
      return MemoryImage(source as Uint8List);
    }
    return CachedNetworkImageProvider(source as String);
  }
}