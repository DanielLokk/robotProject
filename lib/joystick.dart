import 'package:flutter/material.dart';

class JoyStick extends StatefulWidget {
  @override
  _JoyStickState createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick> {
  double xOffset = 0;
  double yOffset = 0;

  @override
  Widget build(BuildContext context) {
    xOffset = 100;
    yOffset = 100;
    return Container(
      decoration: BoxDecoration(color: Colors.amberAccent),
      height: 200,
      width: 200,
      child: Stack(
        children: [
          /* Posiciona relatiu al contenidor superior */
          Positioned(
            top: yOffset,
            right: xOffset,
            child: FloatingActionButton(onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
