import 'package:flutter/material.dart';

class Modo extends StatefulWidget {
  @override
  _ModoState createState() => _ModoState();
}

class _ModoState extends State<Modo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 125,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(child: Text("Attack")),
    );
  }
}
