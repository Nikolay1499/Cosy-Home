import 'package:flutter/material.dart';
import 'package:flutter_hack/camera.dart';
import 'package:flutter_hack/size.dart';
import 'package:flutter_hack/display.dart';
import 'package:flutter_hack/main.dart';

String selectedType;

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Color(0xffc3b091),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: SizeConfig.blockSizeVertical * 60,
                width: SizeConfig.blockSizeHorizontal * 75,
                child:  Column(
                  children: <Widget>[
                    Text("Cosy Home", style: TextStyle(fontSize: 100),textAlign: TextAlign.center,),
                    Image(image: AssetImage("assets/home.png"),),
                  ]),
                
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5,),
              Column(
                children: [
                  SizedBox(height: SizeConfig.blockSizeVertical * 5,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    color: Color(0xff91a4c3),
                    onPressed: () {
                      checkInternet().then((intenet) {
                        if (intenet != null && intenet) {
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => CameraScreen(camera: firstCamera),
                              ),
                            );
                        }
                        else
                          noInternetPanel(context);
                      });
                    
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Start',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 10,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ),
                      ),
                  ), 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
