import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class Feed extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    return Mjpeg(
      isLive: isRunning.value,
      //stream: 'http://83.46.131.246:1024/html/cam_pic_new.php',
      stream: 'http://91.133.85.170:8090/cgi-bin/faststream.jpg',
    );
  }
}
