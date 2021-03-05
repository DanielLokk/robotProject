import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robotApplication/feed.dart';
import 'joystick.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
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
  final _localRenderer = new RTCVideoRenderer();

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initRenderer();
    _getUserMedia();

    super.initState();
  }

  initRenderer() async {
    await _localRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        // Uncoment to have frontal facecam
        //'facingMode': 'user',
      },
    };

    MediaStream stream = await MediaDevices.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* container to align on the bottom  */
      body: Container(
        decoration: BoxDecoration(
            /* image: DecorationImage(
            image: AssetImage("assets/image.png"),
            fit: BoxFit.cover,
          ), */
            ),
        child: Stack(
          children: <Widget>[
            /// Camera RTC for the moment is not connected to the raspberry
            Positioned(
              top: 25,
              left: 125,
              right: 125,
              bottom: 25,
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Feed(),
              ),
            ),

            /// Joystick left, vertical movement
            Positioned(
              bottom: 5,
              left: 100,
              child: JoyStick(
                database: widget.database,
                direction: JoyStick.vertical,
                motor: "left",
              ),
            ),

            /// Joystick right, horizontal movement
            Positioned(
              bottom: 5,
              right: 100,
              child: JoyStick(
                database: widget.database,
                direction: JoyStick.vertical,
                motor: "right",
              ),
            ),

            /// Attack / Defense modo
            Positioned(
              top: 20,
              left: 20,
              child: Modo(database: widget.database),
            ),
          ],
        ),
      ),
    );
  }
}
