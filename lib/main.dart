import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as Vector;
import './LightBar.dart';
import './GradientLightBar.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double rotateX;
  double progress;

  Vector.Matrix4 getBaseMatrix() {
    return Vector.Matrix4.identity()
      ..setEntry(3, 2, 0.002)
      ..rotateX(rotateX);
  }

  @override
  initState() {
    super.initState();
    rotateX = pi * 0.2;
    progress = 0.32;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size boxSize = Size(screenSize.width * 0.7, 50);

    return Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 240)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GradientLightBar(colors: [Colors.pink[100].withOpacity(0.5), Colors.pink[800].withOpacity(0.8)], rotateX: pi * 0.21, progress: 0.7),
            GradientLightBar(colors: [Colors.amber[100].withOpacity(0.5), Colors.amber[800].withOpacity(0.8)], rotateX: pi * 0.31, progress: 0.3),
            GradientLightBar(
                colors: [Colors.lightBlue[100].withOpacity(0.5), Colors.lightBlue[400].withOpacity(0.8)], rotateX: pi * 0.31, progress: 0.8),
          ],
        ));
  }
}
