import 'package:flutter_hack/start.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_hack/display.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_hack/size.dart';
import 'package:flutter_hack/words.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final List<String> existingList;
  const CameraScreen({
    Key key,
    @required this.camera,
    this.existingList,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = MediaQuery.of(context).size.width;
  
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              StartScreen(),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xffc3b091),
        body: Transform.translate(
          offset: Offset(0, 24),
          child: Container(
            height: SizeConfig.blockSizeVertical * 80,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ), 
        ),         
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Transform.translate(
          offset: Offset(0, -15),
          child: widget.existingList == null ?
            FloatingActionButton(
              child: Icon(Icons.camera_alt),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final path = join(
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png',
                  );
                  await _controller.takePicture(path);
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => 
                        DisplayPictureScreen(imagePath: File(path)),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
            )
            :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: Icon(Icons.camera_alt),
                  onPressed: () async {
                    try {
                      await _initializeControllerFuture;
                      final path = join(
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );
                      await _controller.takePicture(path);
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => 
                                DisplayPictureScreen(imagePath: File(path), 
                                  existingList: widget.existingList),
                        ),
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  heroTag: "photo",
                ),
                SizedBox(width: width / 3.6),
                FloatingActionButton(
                  heroTag: "back",
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          WordsScreen(emotions: null, 
                            existingList: widget.existingList),
                      ),
                    );
                  },
                ),
              ],
            ),
        ),
        
      ),
    );
  }
}