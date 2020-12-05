import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
  double xOffset = 62.5;

  /// Offset of the Y axis. it's used to determine the position
  /// of the joystick vertically
  double yOffset = 62.5;

  bool onMove = false;

  GlobalKey _keyBall = GlobalKey();

  /// Sends motor update
  void updateData(motor, value) =>
      widget.database.child(motor).update({'move': value});

  /// Ball of the joystick
  void _getPositions(BuildContext context, DragUpdateDetails details) {
    final RenderBox renderBoxRed = _keyBall.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Red: $positionRed ");
  }

  @override
  Widget build(BuildContext context) {
    double startOffset = 62.5;

    /// container that sets the limit of the gesture box
    return widget.direction == JoyStick.vertical
        ? Container(
            decoration: BoxDecoration(color: Colors.grey),
            height: 200,
            width: 200,
            child: GestureDetector(
              /// Takes only vertical updates
              onVerticalDragUpdate: (details) {
                setState(() {
                  double dy = details.localPosition.dy;
                  onMove = true;

                  /// If it's within the limits of the container, move vertically.
                  /// the +25 is to center the pointer with the circle
                  if (dy >= 25 && dy <= 150) {
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
                  /// Joystick ball
                  Positioned(
                    top: yOffset,
                    left: startOffset,
                    child: Container(
                      key: _keyBall,
                      width: 75.0,
                      height: 75.0,
                      child: new RawMaterialButton(
                        shape: new CircleBorder(),
                        elevation: 5.0,
                        onPressed: () {},
                        fillColor: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(color: Colors.lightBlue),
            height: 200,
            width: 200,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  double dx = details.localPosition.dx;

                  /// If it's within the limits of the container, move horizontally
                  if (dx >= 25 && dx <= 150) {
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
                  onMove = false;
                  xOffset = startOffset;
                  updateData('right', 0);
                });
              },
              child: Stack(
                children: [
                  /// Joystick ball
                  Positioned(
                    top: startOffset,
                    left: xOffset,
                    child: Container(
                      key: _keyBall,
                      width: 75.0,
                      height: 75.0,
                      child: new RawMaterialButton(
                        shape: new CircleBorder(),
                        elevation: 5.0,
                        onPressed: () {},
                        fillColor: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
