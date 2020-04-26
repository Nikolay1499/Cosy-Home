import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:image_crop/image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hack/display.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CropScreen extends StatefulWidget {
  final File image;
  final List<String> existingList;
  const CropScreen({
    Key key,
    @required this.image,
    @required this.existingList,
  }) : super(key: key);

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {

  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped;

  @override
  void initState() {
    super.initState();
    _file = widget.image;
    print(_file);
  }

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }


  @override
  Widget build(BuildContext context)
  {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              DisplayPictureScreen(imagePath: widget.image
                      , existingList: widget.existingList),
          ),
        );
      },
      child: Scaffold(
        body: _buildCroppingImage(width, height),
      ),
    );
  }


  Widget _buildCroppingImage(double width, double height) {
    return Container(
      color: Colors.cyan, 
      child: Column(
        children: <Widget>[
          Expanded(
            child: Crop.file(widget.image, key: cropKey),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20.0),
            alignment: AlignmentDirectional.center,
            child: Transform.translate(
              offset: Offset(0, -15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "crop",
                    onPressed: _cropImage,
                    tooltip: 'Crop image',
                    child: Icon(Icons.save),
                  ),
                  SizedBox(width: width / 4),
                  FloatingActionButton(
                    heroTag: "back",
                    child: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => 
                            DisplayPictureScreen(imagePath: widget.image
                                  , existingList: widget.existingList),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    if (FileSystemEntity.typeSync(_file.path) !=
        FileSystemEntityType.notFound) {
        final sample = await ImageCrop.sampleImage(
          file: _file,
          preferredSize: (2000 / scale).round(),
        );

        final file = await ImageCrop.cropImage(
          file: sample,
          area: area,
        );

        sample.delete();

        _lastCropped?.delete();
        _lastCropped = file;

        final path = join(
          (await getTemporaryDirectory()).path,
          '${DateTime.now()}.png',
        );
        final File newImage = await file.copy(path);

        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              DisplayPictureScreen(imagePath: newImage
                  , existingList: widget.existingList,),
          ),
        );
    } 
    else{
      print("oops");
    }
    
  }
}