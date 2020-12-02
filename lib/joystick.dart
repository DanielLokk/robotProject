import 'package:flutter/material.dart';

class JoyStick extends StatefulWidget {
  @override
  _JoyStickState createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick> {
  double xOffset = 0;
  double yOffset = 75;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.amberAccent),
      height: 200,
      width: 200,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            double dy = details.localPosition.dy;
            /* if it's within the limits of the container, move vertically */
            if (dy >= 0 && dy <= 145) {
              yOffset = dy;
            }
          });
        },
        onVerticalDragEnd: (details) {
          setState(() {
            yOffset = 75;
          });
        },
        child: Stack(
          children: [
            /* Posiciona relatiu al contenidor superior */
            Positioned(
              top: yOffset,
              left: 70,
              child: FloatingActionButton(onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
