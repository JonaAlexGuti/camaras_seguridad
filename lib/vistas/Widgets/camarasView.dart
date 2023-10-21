import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

import '../../generated/l10n.dart';

class CamaraView extends HookWidget {
  String dirCam;
  CamaraView(this.dirCam, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    final isRunning = useState(true);
    return SizedBox(

      child: Mjpeg(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        isLive: isRunning.value,
        error: (context, error, stack) {
          return Center(
              child: Text(S.of(context).cammen,
              style: const TextStyle(color: Colors.red))
          );},
        stream:"http://${dirCam}",
      ),
    );
  }
}