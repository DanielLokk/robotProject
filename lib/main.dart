import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/vlc_player.dart';
import 'joystick.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_vlc_player/vlc_player_controller.dart';

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
  String _streamURL;
  VlcPlayerController _vlcPlayerController;

  @override
  void initState() {
    super.initState();
    _vlcPlayerController = new VlcPlayerController();
    _streamURL = 'wbfejnk';
  }

  void setUrl() {
    setState(() {
      if (_streamURL != null) {
        _streamURL = null;
      } else {
        _streamURL = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* container to align on the bottom  */
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _streamURL == null
                ? Container()
                : VlcPlayer(
                    defaultHeight: 200,
                    defaultWidth: 200,
                    url: _streamURL,
                    controller: _vlcPlayerController,
                    placeholder: Container(),
                  ),
            Row(
              children: [
                /* maybe this needs to be changed later for responsiveness */
                JoyStick(
                  database: widget.database,
                  direction: JoyStick.vertical,
                ),
                JoyStick(
                  database: widget.database,
                  direction: JoyStick.horizontal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
