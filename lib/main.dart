import 'dart:ui';

import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robotApplication/feed.dart';
import 'package:robotApplication/mrive.dart';
import 'assets.dart';
import 'joystick.dart';
import 'package:firebase_database/firebase_database.dart';

import 'modo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = FirebaseDatabase.instance.reference();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robot Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: HomePage(database: database),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    @required this.database,
  }) : super(key: key);

  final DatabaseReference database;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* container to align on the bottom  */
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_switch.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            /// Camera RTC for the moment is not connected to the raspberry
            Positioned(
              top: 15,
              left: 175,
              right: 175,
              bottom: 148,
              child: Container(
                decoration: BoxDecoration(
                    //boxShadow: [BoxShadow(spreadRadius: 3.5, color: siscinc)],
                    border: Border.all(width: 7, color: darkPurple),
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  width: 300,
                  height: 251,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    color: c4c4c4,
                  ),
                  child: Feed(),
                ),
              ),
            ),

            /// Joystick left, vertical movement
            Positioned(
              bottom: 12,
              left: 160,
              child: JoyStick(
                database: widget.database,
                direction: JoyStick.vertical,
                motor: "left",
              ),
            ),

            /// Joystick right, horizontal movement
            Positioned(
              bottom: 12,
              right: 160,
              child: JoyStick(
                database: widget.database,
                direction: JoyStick.vertical,
                motor: "right",
              ),
            ),

            /// Arrow up image
            Positioned(
              bottom: 175,
              left: 100,
              child: Image(image: AssetImage("assets/Arrow up.png")),
            ),

            /// Arrow up image
            Positioned(
              bottom: 175,
              right: 100,
              child: Image(image: AssetImage("assets/Arrow up.png")),
            ),

            /// Arrow down image
            Positioned(
              bottom: 40,
              right: 100,
              child: Image(image: AssetImage("assets/Arrow down.png")),
            ),

            /// Arrow down image
            Positioned(
              bottom: 40,
              left: 100,
              child: Image(image: AssetImage("assets/Arrow down.png")),
            ),

            /// Ray gun image
            Positioned(
                bottom: 110,
                left: 447,
                child: Image(
                  image: AssetImage("assets/ray_gun.png"),
                )),

            /// ON - OFF atack modo
            Positioned(
              bottom: 10,
              left: 438,
              child: Container(
                height: 96,
                width: 50,
                child: Stack(
                  children: [
                    MRive(
                      database: widget.database,
                    ),
                    Column(
                      children: [
                        Container(
                          child:
                              Text("OFF", style: TextStyle(color: darkPurple)),
                          padding: EdgeInsets.only(left: 11, top: 17),
                        ),
                        Container(
                          child:
                              Text("ON", style: TextStyle(color: darkPurple)),
                          padding: EdgeInsets.only(left: 13, top: 27),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
