import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'assets.dart';

class JoyStick extends StatefulWidget {
  @override
  _JoyStickState createState() => _JoyStickState();

  static const int horizontal = 0;
  static const int vertical = 1;

  /// var that determines wether the joystick moves vertically
  /// or horizontally
  final int direction;

  final String motor;

  /// reference to motor in the database
  final DatabaseReference database;
  JoyStick({
    this.database,
    this.direction = vertical,
    this.motor,
  });
}

class _JoyStickState extends State<JoyStick> {
  /// Offset of the X axis. it's used to determine the position
  /// of the joystick horizontally
  double xOffset = 85;

  /// Offset of the Y axis. it's used to determine the position
  /// of the joystick vertically
  double yOffset = 85;

  double startOffset = 85;

  /// Sends motor update
  void updateData(motor, value) async =>
      widget.database.child(motor).update({'move': value});

  /// Outline decoration box
  var decorationOutline = BoxDecoration(
    boxShadow: [
      BoxShadow(
          spreadRadius: 0.5,
          color: rebeliousRed,
          offset: Offset.fromDirection(-180, 5))
    ],
    borderRadius: BorderRadius.all(Radius.circular(5)),
    border: Border.all(color: Colors.grey[600]),
    color: c4c4c4,
  );

  // Normalizes output between [-1, 1]
  double normalize(val, min, max) {
    return 2 * ((val - min) / (max - min)) - 1;
  }

  /// Joystick ball
  var joystickBall = Container(
    height: 75.0,
    width: 75.0,
    child: RawMaterialButton(
      shape:
          CircleBorder(side: BorderSide(color: Colors.grey[600], width: 2.5)),
      elevation: 15.0,
      highlightColor: Colors.transparent,
      fillColor: rebeliousRed,
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    double maxBottomOffset = startOffset + 100;
    double maxTopOffset = startOffset - 50;

    /// depending on the direction its a vertical container or horizontal
    return widget.direction == JoyStick.vertical
        ? GestureDetector(
            /// Takes only vertical updates
            onVerticalDragUpdate: (details) {
              setState(() {
                double dy = details.localPosition.dy;

                /// If it's within the limits of the container, move vertically.
                if (dy > maxTopOffset && dy < maxBottomOffset) {
                  yOffset = dy - 25;

                  /// Updates the database depending the offset
                  updateData(
                    widget.motor,
                    normalize(dy, maxBottomOffset, maxTopOffset),
                  );
                }
              });
            },

            /// When the user drag ends, the position is set to origin
            onVerticalDragEnd: (details) {
              setState(() {
                yOffset = startOffset;
                updateData(widget.motor, 0);
              });
            },

            /// Joystick and Outline
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  height: 200,
                  width: 75,
                  decoration: decorationOutline,
                ),

                /// Arrow up image
                Positioned(
                  top: 35,
                  left: 14,
                  child: Image(image: AssetImage("assets/Arrow up.png")),
                ),

                /// Arrow down image
                Positioned(
                  bottom: 25,
                  left: 14,
                  child: Image(image: AssetImage("assets/Arrow down.png")),
                ),

                /// Joystick ball
                Positioned(
                  top: yOffset,
                  left: 0,
                  child: joystickBall,
                ),
              ],
            ),
          )
        : GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                double dx = details.localPosition.dx;

                /// If it's within the limits of the container, move horizontally
                if (dx >= maxTopOffset && dx <= maxBottomOffset) {
                  xOffset = dx - 25;

                  /// Updates the data depending on the offset
                  updateData(
                    "right",
                    normalize(dx, maxBottomOffset, maxTopOffset) * (-1),
                  );
                }
              });
            },

            /// When the user drag ends, the position is set to origin */
            onHorizontalDragEnd: (details) {
              setState(() {
                xOffset = startOffset;
                updateData('right', 0);
              });
            },

            // Joystick and Outline
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 75, left: 25, right: 25),
                  decoration: decorationOutline,
                  height: 75,
                  width: 200,
                ),

                /// Joystick ball
                Positioned(
                  top: 0,
                  left: xOffset,
                  child: joystickBall,
                ),
              ],
            ),
          );
  }
}
