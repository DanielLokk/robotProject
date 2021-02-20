import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Modo extends StatefulWidget {
  @override
  _ModoState createState() => _ModoState();

  final DatabaseReference database;

  Modo({this.database});
}

class _ModoState extends State<Modo> {
  // Defines with text the current state of the button
  String modo = "Attack";

  /// Sends motor update
  void updateData(value) async =>
      widget.database.child("modo").update({'move': value});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // When tapped, mode changes
      onTap: () {
        setState(() {
          modo = modo == "Attack" ? "Defense" : "Attack";
          updateData(modo);
        });
      },
      child: Container(
        height: 50,
        width: 125,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(modo),
        ),
      ),
    );
  }
}
