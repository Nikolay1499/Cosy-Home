import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hack/camera.dart';
import 'package:flutter_hack/main.dart';
import 'package:flutter_hack/size.dart';
import 'package:flutter_hack/words.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hack/models.dart';
import 'package:flutter_hack/key.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_hack/crop.dart';

  Future<bool> checkInternet() async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else
      return false;
  }

  Future<void> noInternetPanel(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AutoSizeText('Problem',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          content: AutoSizeText('No internet. Please connect to ' 
                      + 'a wifi or network and try again',
            maxLines: 5,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: AutoSizeText('ОК',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


class DisplayPictureScreen extends StatefulWidget {

  final File imagePath;
  final List<String> existingList;
  const DisplayPictureScreen({Key key, @required this.imagePath, 
      this.existingList}) : super(key: key);
  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  bool isWaiting = false;




  //Used for onDevice OCR
  /*Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(widget.imagePath);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => 
          WordsScreen(readText: readText, 
          existingList: widget.existingList == null ? [] : widget.existingList,),
      ),
    );
    
  }*/

  //Use this request to use the cloud to non-Latin characters
  Future readText() async
  {

    setState(() {
     isWaiting = true; 
    });

    var timer = Timer(Duration(seconds: 20), () {
      _ackAlert(context);
    });

    String base64Image = base64Encode(widget.imagePath.readAsBytesSync());
    String body = """{
      'requests': [
        {
          'image': {
            'content' : '$base64Image'
          },
          'features': [
            {
              'type': 'FACE_DETECTION'
            }
          ]
        }
      ]
    }""";

    http.Response res = await http
      .post(
        APIKey.getKey(),
        body: body
      );


    final jsonResponse = json.decode(res.body);
    Responses responses = new Responses.fromJson(jsonResponse);

    if(responses != null)
    {
      timer.cancel();
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => 
            WordsScreen(emotions: responses.responses[0].faceAnnotations[0].emotions, 
            existingList: widget.existingList == null ? [] : widget.existingList,),
        ),
      );
    }
  }


  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AutoSizeText('Ooops',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          content: AutoSizeText('No person has been detected in that image. Please try again!',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: AutoSizeText('ОК',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => 
                      CameraScreen(camera: firstCamera, existingList: widget.existingList),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
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
              CameraScreen(camera: firstCamera, existingList: widget.existingList),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xffc3b091),
        body: 
          !isWaiting ?
            Transform.translate(
              offset: Offset(0, 19),
              child:
                Transform(
                  alignment: Alignment.center,
                  child: Container(
                    height: SizeConfig.blockSizeVertical * 80,
                    child : Image.file(widget.imagePath),
                  ),
                  transform: Matrix4.rotationY(math.pi),
                )           
            )
          :
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText("Please Wait",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 50, 
                      color: Colors.white
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 20),
                    child: SpinKitPouringHourglass(
                      color: Colors.white, 
                      size: 200),
                  ),
                ],
              ),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Transform.translate(
          offset: Offset(0, -15),
          child:
          !isWaiting ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: Icon(Icons.check),
                  onPressed: () {
                    checkInternet().then((intenet) {
                      if (intenet != null && intenet) {
                        readText();
                      }
                      else
                        noInternetPanel(context);
                    });
                  },
                  heroTag: "textTag",
                ),
                SizedBox(width: width / 9),
                FloatingActionButton(
                  heroTag: "crop",
                  onPressed: (){
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          CropScreen(image: widget.imagePath, 
                                existingList: widget.existingList,),
                      ),
                    );
                  },
                  tooltip: 'Crop image',
                  child: Icon(Icons.crop),
                ),
                SizedBox(width: width / 9),
                FloatingActionButton(
                  heroTag: "back",
                  child: Icon(Icons.clear),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          CameraScreen(camera: firstCamera, existingList: widget.existingList),
                      ),
                    );
                  },
                ),
              ],
            )
          :
            null,
        ),
      ),
    );
  }
}
