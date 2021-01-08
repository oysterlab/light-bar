import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as Vector;

class LightBar extends StatefulWidget {
  double rotateX;
  double progress;
  Color color;

  LightBar({this.rotateX, this.progress, this.color});

  @override
  _LightBarState createState() => _LightBarState();
}

class _LightBarState extends State<LightBar> {
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
            decoration: BoxDecoration(
                color: widget.color.withOpacity(0.5),
                boxShadow: [BoxShadow(color: widget.color.withOpacity(0.8), blurRadius: 10 * progress, spreadRadius: 20 * progress)]),
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
            decoration: BoxDecoration(color: Colors.grey[300].withOpacity(0.2)),
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
            decoration: BoxDecoration(
                color: widget.color.withOpacity(0.7),
                boxShadow: [BoxShadow(color: widget.color.withOpacity(0.8), blurRadius: 30 * progress, spreadRadius: 20 * progress)]),
          ),
        )
      ]),
    );
  }
}
