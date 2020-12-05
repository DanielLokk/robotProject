import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'assets.dart';

class JoyStick extends StatefulWidget {
  @override
  _JoyStickState createState() => _JoyStickState();

  static const horizontal = 0;
  static const vertical = 1;

  /// var that determines wether the joystick moves vertically
  /// or horizontally
  final int direction;

  /// reference to motor in the database
  final DatabaseReference database;
  JoyStick({
    this.database,
    this.direction = vertical,
  });
}

class _JoyStickState extends State<JoyStick> {
  /// Offset of the X axis. it's used to determine the position
  /// of the joystick horizontally
  double xOffset = 85;

  /// Offset of the Y axis. it's used to determine the position
  /// of the joystick vertically
  double yOffset = 85;

  double startOffset = 82.5;

  GlobalKey _keyBall = GlobalKey();

  /// Sends motor update
  void updateData(motor, value) =>
      widget.database.child(motor).update({'move': value});

  /// Ball of the joystick global position
  void _getPositions(BuildContext context, DragUpdateDetails details) {
    final RenderBox renderBoxRed = _keyBall.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Red: $positionRed ");
  }

  var decorationOutline = BoxDecoration(
    boxShadow: [BoxShadow(spreadRadius: 2.75, color: siscinc)],
    color: c4c4c4,
  );

  var joystickBall = Container(
    height: 75.0,
    width: 75.0,
    child: RawMaterialButton(
      shape: new CircleBorder(),
      elevation: 15.0,
      highlightColor: Colors.transparent,
      onPressed: () {},
      fillColor: rebeliousRed,
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
                  if (dy > startOffset + 5) {
                    updateData('left', -1);
                  } else if (startOffset - 5 <= dy && dy <= startOffset + 5) {
                    updateData('left', 0);
                  } else if (dy < startOffset - 2) {
                    updateData('left', 1);
                  }
                }
              });
            },

            /// When the user drag ends, the position is set to origin
            onVerticalDragEnd: (details) {
              setState(() {
                yOffset = startOffset;
                updateData('left', 0);
              });
            },
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  height: 200,
                  width: 75,
                  decoration: decorationOutline,
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
                  if (dx > startOffset + 5 + 25) {
                    updateData('right', -1);
                  } else if (startOffset - 5 + 25 <= dx &&
                      dx <= startOffset + 5 + 25) {
                    updateData('right', 0);
                  } else if (dx < startOffset - 2 + 25) {
                    updateData('right', 1);
                  }
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
