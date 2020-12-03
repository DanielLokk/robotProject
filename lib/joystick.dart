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

  /* sends motor update */
  void updateData(value) {
    widget.database.child('left').update({'move': value});
    /* widget.database.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    }); */
  }

  @override
  Widget build(BuildContext context) {
    double startOffset = 75;
    /* container that sets the limit of the gesture box */
    return Column(
      children: [
        Container(
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

                  /* updates the data depending on the offset */
                  if (dy > startOffset + 5) {
                    updateData(-1);
                  } else if (startOffset - 5 <= dy && dy <= startOffset + 5) {
                    updateData(0);
                  } else if (dy < startOffset - 2) {
                    updateData(1);
                  }
                }
              });
            },
            /* when the user drag ends, the position is set to origin */
            onVerticalDragEnd: (details) {
              setState(() {
                yOffset = 75;
                updateData(0);
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
        ),
        Text("$yOffset"),
      ],
    );
  }
}
