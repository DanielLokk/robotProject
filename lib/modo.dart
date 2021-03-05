import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Modo extends StatefulWidget {
  @override
  _ModoState createState() => _ModoState();

  final DatabaseReference database;

  Modo({this.database});
}

class _ModoState extends State<Modo> {
  bool status = false;

  /// Sends motor update
  void updateData(value) async =>
      widget.database.child("modo").update({'move': value});

  void initState() {
    super.initState();
    updateData(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomSwitch(
          value: status,
          onChanged: (value) {
            setState(() {
              status = status == true ? false : true;
            });
            updateData(status);
          },
          activeColor: Colors.pinkAccent,
        ),

        // Separation
        SizedBox(
          height: 12.0,
        ),

        // Attack mode text
        Text(
          'Attack Mode',
          style:
              TextStyle(color: Colors.black, fontSize: 15.0, letterSpacing: .5),
        ),
      ],
    );
  }
}
