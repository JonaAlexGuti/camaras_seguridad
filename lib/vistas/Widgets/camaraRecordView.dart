import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_recorder/screen_recorder.dart';
import 'package:wid_mage/wid_mage.dart';
import '../../generated/l10n.dart';

class camaraRecordView extends StatefulWidget {
  String dirCam;
  camaraRecordView(this.dirCam, {Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState(dirCam);
}

class _DetailState extends State<camaraRecordView> {
  String dirCam;
  _DetailState(this.dirCam);

  GlobalKey _globalKey = GlobalKey();
  ScreenRecorderController controller = ScreenRecorderController();

  bool _recording = false;
  bool _exporting = false;
  bool get canExport => controller.exporter.hasFrames;

  late String _timeString;
  late bool isRunning;
  late var timer;
  late String message;

  @override
  void initState() {
    super.initState();
    isRunning = true;
    if (mounted) {
      _timeString = _formatDateTime(DateTime.now());
      timer =
          Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    }
  }

  @override
  void dispose() {
    timer.cancel;
    isRunning = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        SizedBox(
          child: ScreenRecorder(
            height: 300,
            width: 400,
            controller: controller,
            child: WidMage(
              globalKey: _globalKey,
              child: Stack(
                children: <Widget>[
                  GestureZoomBox(
                    maxScale: 5.0,
                    doubleTapScale: 2.0,
                    duration: const Duration(milliseconds: 100),
                    child: Mjpeg(
                      isLive: isRunning,
                      error: (context, error, stack) {
                        return Center(
                            child: Text(S.of(context).cammen,
                                style: const TextStyle(color: Colors.red)));
                      },
                      stream: "http://$dirCam",
                    ),
                  ),
                  Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: <Widget>[
                            Text(
                              _timeString,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  videoButton(),
                  IconButton(
                    icon: const Icon(
                      Icons.photo_camera,
                      size: 24,
                      color: Colors.white60,
                    ),
                    onPressed: takeScreenShot,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  Widget videoButton() {
    if (!_recording) {
      return IconButton(
        icon: const Icon(
          Icons.videocam,
          size: 24,
          color: Colors.white60,
        ),
        onPressed: takeVideoOn,
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.videocam,
          size: 24,
          color: Colors.red,
        ),
        onPressed: takeVideoOff,
      );
    }
  }

  takeScreenShot() async {
    try {
      Uint8List? image =
          await WidMageController.onCaptureImage(globalKey: _globalKey);

      //guarda la imagen en el dispositivo
      final result = await ImageGallerySaver.saveImage(image!);
      Fluttertoast.showToast(
          msg: result != null ? S.of(context).SS_Saved : S.of(context).SS_Fail,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      rethrow;
    }
  }

  takeVideoOn() async {
    if (!_recording && !_exporting) {
      controller.start();
      setState(() {
        _recording = true;
        message = S.of(context).SR_Start;
      });
    }
    FloatMessage(message, Colors.red);
  }

  takeVideoOff() async {
    final tempDir = await getTemporaryDirectory();
    final videoPath = '${tempDir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final imagePaths = <String>[];
    if (_recording && !_exporting) {
      controller.stop();
      setState(() {
        _recording = false;
        message = S.of(context).SR_Stop;
      });
      FloatMessage(message, Colors.green);

      if (canExport && !_exporting) {
        setState(() {
          _exporting = true;
        });

        var gif = await controller.exporter.exportGif();
        if (gif == null) {
          FloatMessage("Error", Colors.green);
          throw Exception();
        }
        setState(() => _exporting = false);

        for (int i = 0; i < gif.length; i++) {
          final imagePath = '${tempDir.path}/image$i.png';
          await File(imagePath).writeAsBytes(Uint8List.fromList(gif));
          imagePaths.add(imagePath);
        }
        try {

          print(Uint8List.fromList(gif));
          FFmpegKit.execute('-i ${tempDir.path}/image%d.png -c:v libx264 $videoPath')
              .then((session) async {
            final returnCode = await session.getReturnCode();

            if (ReturnCode.isSuccess(returnCode)) {
              print("succes");
              // SUCCESS
            } else if (ReturnCode.isCancel(returnCode)) {
              print("cancel");
              // CANCEL
            } else {
              print("error");
              print(await session.getFailStackTrace());
              // ERROR
            }
          });
          FloatMessage("Exportando", Colors.green);
          //guarda la imagen en el dispositivo
        } catch (e) {
          rethrow;
        }
        //print(outputPath);
        /*
      GallerySaver.saveVideo(outputPath).then((result) {
        print("Video Save result : $result");
        VideoUtil.deleteTempDirectory();
      });
       */
      }
    }
    setState(() {
      controller.exporter.clear();
    });
  }

  FloatMessage(String mess, Color color) {
    return Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss aaa dd/MM/yyyy').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = _formatDateTime(now);
      });
    }
  }
}
