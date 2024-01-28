import "dart:io";

import "package:flutter/material.dart";
import 'package:camera/camera.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;

  const TakePicturePage({Key? key, required this.camera}) : super(key: key);

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  late CameraController _cameraController;
  late Future _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.max);
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _takePicture(BuildContext context) async {
    try {
      if (!_cameraController.value.isTakingPicture) {
        XFile image = await _cameraController.takePicture();
        if (!mounted) return;
        Navigator.pop(context, image);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              const SnackBar(content: Text('Already taking a picture.')));
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera),
          onPressed: () => _takePicture(context)),
      body: FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_cameraController));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
