import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularIndicator extends StatefulWidget {
  double? indicatorRadius;
  Color? indicatorColor;
  CircularIndicator({this.indicatorRadius, this.indicatorColor});
  @override
  State<StatefulWidget> createState() {
    return _CircularIndicatorState();
  }

}

const double _kDefaultIndicatorRadius = 10.0;
// Extracted from iOS 13.2 Beta.
const Color _kActiveTickColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFF3C3C44),
  darkColor: Color(0xFFEBEBF5),
);
class _CircularIndicatorState extends State<CircularIndicator> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller?.repeat();
  }

  @override
  void didUpdateWidget(CircularIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _controller.repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.indicatorRadius != null && widget.indicatorRadius! > 0 ?  widget.indicatorRadius! * 2 : _kDefaultIndicatorRadius * 2,
      width: widget.indicatorRadius != null && widget.indicatorRadius! > 0 ?  widget.indicatorRadius! * 2 : _kDefaultIndicatorRadius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          position: _controller??(_controller = AnimationController(
            duration: const Duration(seconds: 1),
            vsync: this,
          )),
          activeColor: CupertinoDynamicColor.resolve(widget.indicatorColor??_kActiveTickColor, context),
          radius: widget.indicatorRadius != null && widget.indicatorRadius! > 0 ?  widget.indicatorRadius! : _kDefaultIndicatorRadius,
          progress: 1.0,
        ),
      ),
    );
  }

}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;

// Alpha values extracted from the native component (for both dark and light mode) to
// draw the spinning ticks. The list must have a length of _kTickCount. The order of
// these values is designed to match the first frame of the iOS activity indicator which
// has the most prominent tick at 9 o'clock.
const List<int> _alphaValues = <int>[100, 100, 120, 140, 160, 180, 195, 210, 225, 240, 255, 100];

// The alpha value that is used to draw the partially revealed ticks.
const int _partiallyRevealedAlpha = 255;

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    required this.position,
    required this.activeColor,
    required this.radius,
    required this.progress,
  }) : tickFundamentalRRect = RRect.fromLTRBXY(
    -radius / _kDefaultIndicatorRadius,
    -radius / 2.0,
    radius / _kDefaultIndicatorRadius,
    -radius,
    radius / _kDefaultIndicatorRadius,
    radius / _kDefaultIndicatorRadius,
  ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;
  final Color activeColor;
  final double radius;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount * progress; ++i) {
      final int t = (i - activeTick) % _kTickCount;
      paint.color = activeColor.withAlpha(progress < 1 ? _partiallyRevealedAlpha : _alphaValues[t]);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position || oldPainter.activeColor != activeColor || oldPainter.progress != progress;
  }
}