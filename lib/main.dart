import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'joystick.dart';
import 'package:firebase_database/firebase_database.dart';

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
      ),
      home: Scaffold(
        /* container to align on the bottom  */
        body: Container(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              /* maybe this needs to be changed later for responsiveness */
              Padding(padding: EdgeInsets.only(left: 160)),
              JoyStick(
                database: database,
                direction: JoyStick.vertical,
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 100)),
              JoyStick(
                database: database,
                direction: JoyStick.horizontal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
