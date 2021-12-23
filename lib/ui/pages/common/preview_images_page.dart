import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/widgets/circular_progress_bar.dart';
import 'package:flutter_demo_app/ui/widgets/customer_app_bar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rxdart/rxdart.dart';

enum SourceType {
  AssetImage,
  FileImage,
  MemoryImage,
  NetworkImage,
}

class PreviewImagesPage extends StatelessWidget {
  SourceType type;
  String? title;
  List<dynamic>? sourceList;
  int initPosition;

  int currentPosition = 0;
  late PageController _pageController;
  final BehaviorSubject<int> _indicatorController = BehaviorSubject<int>();

  PreviewImagesPage(this.type, this.sourceList, this.initPosition, {this.title}) {
    _pageController = PageController(initialPage: initPosition);
    currentPosition = initPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerAppBar(
        backgroundColor: ResourceColors.theme_background,
        titleContent: title??'图片预览',
        automaticallyImplyLeading: true,
        onWillPop: () {
          Navigator.maybePop(context);
          _indicatorController.close();
        },
      ),
      backgroundColor: Colors.black,
      body: sourceList != null && sourceList!.length > 0 ? Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            itemCount: sourceList!.length,
            builder: (context, index) {
              var item = sourceList![index];
              return PhotoViewGalleryPageOptions(
                imageProvider: _getImageProvider(item),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(tag: index),
                maxScale: 0.65,
                minScale: 0.09,
              );
            },
            loadingBuilder: (context, event) => Center(
              child: CircularProgressBar(
                width: ScreenUtil.getInstance().getAdapterSize(20.0),
                height: ScreenUtil.getInstance().getAdapterSize(20.0),
                accentColor: Theme.of(context).accentColor,
                strokeWidth: 2.0,
              ),
            ),
            pageController: _pageController,
            onPageChanged: onPageChanged,
          ),
          Container(
            height: ScreenUtil.getInstance().getAdapterSize(20.0),
            margin: EdgeInsets.only(
              left: ScreenUtil.getInstance().getAdapterSize(6.0),
              right: ScreenUtil.getInstance().getAdapterSize(6.0),
              bottom: ScreenUtil.getInstance().bottomBarHeight + ScreenUtil.getInstance().getAdapterSize(10.0),
            ),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<int>(
                  initialData: currentPosition,
                  stream: _indicatorController.stream,
                  builder: (context, snap) {
                    int position = currentPosition;
                    if (snap.hasData) {
                      snap.data;
                    }
                    return Row(
                      children: _buildIndicator(position),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ) : Container(),
    );
  }

  ImageProvider? _getImageProvider(dynamic item) {
    if (type == SourceType.AssetImage) {
      return AssetImage(item as String);
    }
    if (type == SourceType.FileImage) {
      return FileImage(item as File);
    }
    if (type == SourceType.MemoryImage) {
      return MemoryImage(item as Uint8List);
    }
    return CachedNetworkImageProvider(item as String);
  }

  List<Widget> _buildIndicator(int currentIndex) {
    List<Widget> pointViews = [];
    for (int i = 0; i < sourceList!.length; i++) {
      Widget itemView = InkWell(
        onTap: () {
          // _pageController?.animateToPage(i, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          _pageController.jumpToPage(i);
        },
        child: Container(
          width: ScreenUtil.getInstance().getAdapterSize(6.0),
          height: ScreenUtil.getInstance().getAdapterSize(6.0),
          decoration: BoxDecoration(
            color: currentIndex == i ? Colors.white : ResourceColors.gray_bb,
            shape: BoxShape.circle,
          ),
        ),
      );
      pointViews.add(itemView);
      pointViews.add(Container(
        width: ScreenUtil.getInstance().getAdapterSize(6.0),
        height: ScreenUtil.getInstance().getAdapterSize(6.0),
      ));
    }
    return pointViews;
  }

  void onPageChanged(int position) {
    if (currentPosition != position) {
      currentPosition = position;
      _indicatorController.sink.add(position);
    }
  }

}