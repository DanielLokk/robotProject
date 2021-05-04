import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';

class MRive extends StatefulWidget {
  @override
  _MRiveState createState() => _MRiveState();

  final DatabaseReference database;

  MRive({this.database});
}

class _MRiveState extends State<MRive> {
  bool status = false;

  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  /// Sends motor update
  void updateData(value) async =>
      widget.database.child("modo").update({'attack': value});

  void _activateArt() {
    setState(() {
      status = status == true ? false : true;
      updateData(status);
      if (status) {
        _riveArtboard.addController(_controller = SimpleAnimation('d to a'));
      } else {
        _riveArtboard.addController(_controller = SimpleAnimation('a to d'));
      }
    });
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/attack_button.riv').then(
      (data) async {
        final file = RiveFile();

        // Load the RiveFile from the binary data.

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        if (file.import(data)) {
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          //artboard.addController(_controller = SimpleAnimation('a to d'));
          //artboard.addController(_controller = SimpleAnimation('d to a'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                spreadRadius: 0.2,
                offset: Offset.fromDirection(-180, 5))
          ]),
      child: InkWell(
        onTap: _activateArt,
        child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard, fit: BoxFit.contain),
      ),
    );
  }
}
