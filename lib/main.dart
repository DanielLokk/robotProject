import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'joystick.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
        'facingMode': 'user',
      },
    };

    MediaStream stream = await MediaDevices.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* container to align on the bottom  */
      body: Stack(
        children: <Widget>[
          /// Camera RTC for the moment is not connected to the raspberry
          Positioned(
            top: 5,
            left: 20,
            right: 20,
            bottom: 400,
            child: Container(
              child: RTCVideoView(_localRenderer),
            ),
          ),

          /// Joystick left, vertical movement
          Positioned(
            bottom: 5,
            left: 200,
            child: JoyStick(
              database: widget.database,
              direction: JoyStick.vertical,
            ),
          ),

          /// Joystick right, horizontal movement
          Positioned(
            bottom: 5,
            right: 200,
            child: JoyStick(
              database: widget.database,
              direction: JoyStick.horizontal,
            ),
          )
        ],
      ),
    );
  }
}
