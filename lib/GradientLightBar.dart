import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as Vector;

class GradientLightBar extends StatefulWidget {
  double rotateX;
  double progress;
  List<Color> colors;

  GradientLightBar({this.rotateX, this.progress, this.colors});

  @override
  _GradientLightBarState createState() => _GradientLightBarState();
}

class _GradientLightBarState extends State<GradientLightBar> {
  double progress;

  initState() {
    super.initState();
    progress = widget.progress;
  }

  Vector.Matrix4 getBaseMatrix() {
    return Vector.Matrix4.identity()
      ..setEntry(3, 2, 0.002)
      ..rotateX(widget.rotateX);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size boxSize = Size(screenSize.width * 0.7, 50);

    double progressWidth = progress * boxSize.width;
    double progressX = -boxSize.width * 0.5 + progressWidth * 0.5;

    return GestureDetector(
      onPanUpdate: (detail) {
        progress += detail.delta.dx * 0.005;
        if (progress < 0) progress = 0.0;
        if (progress > 0.999) progress = 0.999;
        setState(() {});
      },
      child: Stack(alignment: Alignment.center, children: [
        //top
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(0.0, -boxSize.height * 0.5, 0.0)
            ..rotateX(pi * 0.5),
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            decoration: BoxDecoration(color: Colors.grey[300].withOpacity(0.27)),
          ),
        ),
        //top-light
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(progressX, -boxSize.height * 0.5, 0.0)
            ..rotateX(pi * 0.5),
          child: Container(
            width: progressWidth,
            height: boxSize.height,
            child: CustomPaint(painter: ProgressBar(colors: widget.colors.map((color) => color.withOpacity(0.6)).toList(), progress: progress)),
          ),
        ),
        //bottom
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(0.0, boxSize.height * 0.5, 0.0)
            ..rotateX(pi * 0.5),
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            decoration: BoxDecoration(
                color: Colors.grey[300].withOpacity(0.2),
                boxShadow: [BoxShadow(color: Colors.grey[600].withOpacity(0.8), offset: Offset(0.0, -34.0), blurRadius: 50, spreadRadius: 10)]),
          ),
        ),
        //bottom-light
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(progressX, boxSize.height * 0.5, 0.0)
            ..rotateX(pi * 0.5),
          child: Container(
            width: progressWidth,
            height: boxSize.height,
            child: CustomPaint(painter: ProgressBar(colors: widget.colors, progress: progress)),
          ),
        ),
        //back
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(0.0, 0.0, boxSize.height * 0.5)
            ..rotateX(pi * 0.0),
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            decoration: BoxDecoration(color: Colors.grey[300].withOpacity(0.15)),
          ),
        ),
        //back-light
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(progressX, 0.0, boxSize.height * 0.5)
            ..rotateX(pi * 0.0),
          child: Container(
            width: progressWidth,
            height: boxSize.height,
            child: CustomPaint(painter: ProgressBar(colors: widget.colors, progress: progress)),
          ),
        ),
        //front
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(0.0, 0.0, -boxSize.height * 0.5)
            ..rotateX(pi * 0.0),
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            decoration: BoxDecoration(color: Colors.grey[300].withOpacity(0.2)),
          ),
        ),
        //front - light
        Transform(
          alignment: Alignment.center,
          transform: getBaseMatrix()
            ..translate(progressX, 0.0, -boxSize.height * 0.5)
            ..rotateX(pi * 0.0),
          child: Container(
            width: progressWidth,
            height: boxSize.height,
            child: CustomPaint(painter: ProgressBar(colors: widget.colors.map((color) => color.withOpacity(0.5)).toList(), progress: progress)),
          ),
        )
      ]),
    );
  }
}

class ProgressBar extends CustomPainter {
  List<Color> colors;
  double progress;
  final double MAX_RADIUS = 60.0;
  ProgressBar({this.colors, this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..shader = LinearGradient(colors: this.colors).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    double p = MAX_RADIUS * 0.5 * progress;

    paint
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, p)
      ..shader = LinearGradient(colors: this.colors.map((color) => Color.fromARGB(100, color.red, color.green, color.blue)).toList())
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(-p, -p, size.width + p * 2, size.height + p * 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
