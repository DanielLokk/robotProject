import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class JoyStick extends StatefulWidget {
  @override
  _JoyStickState createState() => _JoyStickState();

  /* reference to motor in the database */
  final DatabaseReference database;
  JoyStick({
    this.database,
  });
}

class _JoyStickState extends State<JoyStick> {
  /* offset of the X axis. it's used to determine the position 
  of the joystick horizontally */
  double xOffset = 0;
  /* offset of the Y axis. it's used to determine the position 
  of the joystick vertically */
  double yOffset = 75;

  void updateData() {
    //widget.database.child('left').update({'move': 1});
    widget.database.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    updateData();
    /* container that sets the limit of the gesture box */
    return Container(
      decoration: BoxDecoration(color: Colors.grey),
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
        /* when the user drag ends, the position is set to origin */
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
              child: FloatingActionButton(
                onPressed: () {},
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
