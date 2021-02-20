import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'joystick.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
<<<<<<< HEAD
import 'package:rive/rive.dart';
=======
import 'modo.dart';
>>>>>>> master

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
      /* home: HomePage(database: database), */
      home: MyRiveAnimation(),
    );
  }
}

class MyRiveAnimation extends StatefulWidget {
  @override
  _MyRiveAnimationState createState() => _MyRiveAnimationState();
}

class _MyRiveAnimationState extends State<MyRiveAnimation> {
  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  final riveFileName = 'assets/cybermagnet.riv';
  Artboard _artboard;
  RiveAnimationController _controller;

  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/cybermagnet.riv').then(
      (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('circle'));
          setState(() => _artboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _artboard == null ? const SizedBox() : Rive(artboard: _artboard),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
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
      body: Stack(
        children: <Widget>[
          /// Camera RTC for the moment is not connected to the raspberry
          Positioned(
            top: 20,
<<<<<<< HEAD
            left: 186.5,
            right: 186.5,
            bottom: 100,
=======
            left: 20,
            right: 20,
            bottom: 20,
>>>>>>> master
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 5.0)),
              child: RTCVideoView(_localRenderer),
            ),
          ),

          /// Joystick left, vertical movement
          Positioned(
            bottom: 5,
<<<<<<< HEAD
            left: 150,
=======
            left: 125,
>>>>>>> master
            child: JoyStick(
              database: widget.database,
              direction: JoyStick.vertical,
            ),
          ),

          /// Joystick right, horizontal movement
          Positioned(
            bottom: 5,
            right: 100,
            child: JoyStick(
              database: widget.database,
              direction: JoyStick.horizontal,
            ),
          ),

          /// Attack / Defense modo
          Positioned(
            top: 20,
            left: 20,
            child: Modo(),
          ),
        ],
      ),
    );
  }
}
