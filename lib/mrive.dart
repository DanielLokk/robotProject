import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';

class MRive extends StatefulWidget {
  @override
  _MRiveState createState() => _MRiveState();
}

class _MRiveState extends State<MRive> {
  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
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
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('d to a'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard, fit: BoxFit.contain),
      ),
    );
  }
}
