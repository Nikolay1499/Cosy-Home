import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hack/camera.dart';
import 'package:flutter_hack/main.dart';
import 'package:flutter_hack/webview.dart';

class WordsScreen extends StatefulWidget {

  final List<String> emotions;
  final List<String> existingList;
  final List<String> urls;
  WordsScreen({Key key, @required this.emotions,
                      @required this.existingList,
                      @required this.urls}) : super(key: key);

  @override
  _WordsScreenState createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen>
{ 
  List<String> list = List<String>();
  List<String> urlList = List<String>(4);
  String urlMovie;
  String urlMusic;
  String urlFood;
  int first, second;
  String emotionValue = "You ar feeling neutral";
  @override
  void initState()
  {
    super.initState();
    if(widget.urls != null)
    {
      urlMovie = widget.urls[0];
      urlMusic = widget.urls[1];
      urlFood = widget.urls[2];
      emotionValue = widget.urls[3];
    }
    first = -1;
    second = -1;
    list = widget.existingList;
    if(widget.emotions != null)
    {
      if(widget.emotions[0].substring(0, 4) == "VERY")
        list.add("Anger: " + widget.emotions[0].split("_")[0] + " " + widget.emotions[0].split("_")[1] + "\n");
      else
        list.add("Anger: " + widget.emotions[0] + "\n");
      if(widget.emotions[1].substring(0, 4) == "VERY")
        list.add("Joy: " + widget.emotions[1].split("_")[0] + " " + widget.emotions[1].split("_")[1] + "\n");
      else
      list.add("Joy: " + widget.emotions[1] + "\n");
      if(widget.emotions[2].substring(0, 4) == "VERY")
        list.add("Sorrow: " + widget.emotions[2].split("_")[0] + " " + widget.emotions[2].split("_")[1] + "\n");
      else
      list.add("Sorrow: " + widget.emotions[2] + "\n");
      if(widget.emotions[3].substring(0, 4) == "VERY")
        list.add("Surprise: " + widget.emotions[3].split("_")[0] + " " + widget.emotions[3].split("_")[1] + "\n");
      else
      list.add("Surprise: " + widget.emotions[3] + "\n");
      if(widget.emotions[0] == widget.emotions[1] 
        && widget.emotions[1] == widget.emotions[2] 
        && widget.emotions[2] == widget.emotions[3])
        list.add("Neutral: VERY LIKELY\n");
      else
        list.add("Neutral: VERY UNLIKELY\n");
      if(widget.urls == null)
      {
        int emottion = determineEmotions();
        setLinks(emottion);
        urlList[0] = urlMovie;
        urlList[1] = urlMusic;
        urlList[2] = urlFood;
        urlList[3] = emotionValue;
      }
    }
    else
      urlList = widget.urls;
  }


  int determineEmotions()
  {
    List<int> emotionValues = new List<int>(5);
    for(int i = 0 ; i < 5; i++)
      emotionValues[i] = 0;
    for(int i = 0 ; i < 4; i++)
    {
      if(widget.emotions[i] == "VERY_UNLIKELY")
        emotionValues[i] = 1;
      else if(widget.emotions[i] == "UNLIKELY")
        emotionValues[i] = 2;
      else if(widget.emotions[i] == "POSSIBLE")
        emotionValues[i] = 4;
      else if(widget.emotions[i] == "LIKELY")
        emotionValues[i] = 5;
      else if(widget.emotions[i] == "VERY_LIKELY")
        emotionValues[i] = 6;
    }

    if(emotionValues[0] == emotionValues[1] 
        && emotionValues[1] == emotionValues[2] 
        && emotionValues[2] == emotionValues[3])
      emotionValues[4] = 5;
    int maxIndex = -1;
    int maxValue = -1;

    for(int i = 0 ; i < 5; i++)
    {
      if(maxValue < emotionValues[i])
      {
        maxValue = emotionValues[i];
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  void setLinks(int emotion)
  {
    if(emotion == 0)
    {
      urlMovie = "https://www.imdb.com/search/keyword/?keywords=anger";
      urlMusic = "https://open.spotify.com/playlist/0KPEhXA3O9jHFtpd1Ix5OB";
      urlFood = "https://www.delish.com/cooking/recipe-ideas/a25658638/buffalo-mac-and-cheese-recipe/";
      emotionValue = "You are feeling angry!";
    }
    else if(emotion == 1)
    {
      urlMovie = "https://www.imdb.com/list/ls073638131/";
      urlMusic = "https://open.spotify.com/playlist/1llkez7kiZtBeOw5UjFlJq";
      urlFood = "https://www.bbcgoodfood.com/recipes/one-pan-salmon-roast-asparagus";
      emotionValue = "You are feeling joy!";
    }
    else if(emotion == 2)
    {
      urlMovie = "https://www.imdb.com/list/ls057732578/";
      urlMusic = "https://open.spotify.com/playlist/0S4cQm7WAD01zLr8cUqWmt";
      urlFood = "https://www.delish.com/cooking/a22998721/pizza-pot-pie-recipe/";
      emotionValue = "You are feeling sorrow!";
    }
    else if(emotion == 3)
    {
      urlMovie = "https://www.imdb.com/list/ls059659170/";
      urlMusic = "https://open.spotify.com/playlist/1J9Ku4i3P77krphouOabnh";
      urlFood = "https://www.bbcgoodfood.com/recipes/spanish-meatball-butter-bean-stew";
      emotionValue = "You are feeling surprise!";
    }
    else if(emotion == 4)
    {
      urlMovie = "https://www.imdb.com/list/ls063420772/";
      urlMusic = "https://open.spotify.com/playlist/6xdpuXKNL3CLXEo7xqRWOi";
      urlFood = "https://www.bbcgoodfood.com/recipes/lamb-cooked-tomatoes-aromatic-spices";
      emotionValue = "You are feeling neutral!";
    }
  }

  Widget wordList(int i)
  {
    return GestureDetector(
      child: Container(
        height: 45,
        color: (i == first || i == second) 
          ? Colors.yellow[700] : Color(0xffcec6b0),
        child: Text(
          list[i] + " ",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Comfortaa',
          ),
        ),
      ),
      onTap: (){
        if(first == -1)
          setState(() {
            first = i;
          }); 
        else if(second == -1 && i != first)
          setState(() {
            second = i;
          }); 
        else
        {
          if(i == first)
            setState(() {
              first = -1;
            });
          else if(i == second)
            setState(() {
              second = -1;
            });
          else if(second == -1 && i == first)
            setState(() {
              first = -1;
            });
          else
            setState(() {
              second = i;
            });
        }
      },
    );          
  }



  int wordCount()
  {
    int count = 0;
    if(first <= second)
      for(int i = first; i <= second; i++)
      {
        //print(list[i]);
        if(list[i].substring(list[i].length - 1) != "–" 
                && list[i].substring(list[i].length - 1) != "-")
          count++;
      }
    else
      for(int i = second; i <= first; i++)
        if(list[i].substring(list[i].length - 1) != "–" 
                && list[i].substring(list[i].length - 1) != "-")
          count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => 
              CameraScreen(camera: firstCamera, existingList: null),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xffc3b091),
        body: Transform.translate(
          offset: Offset(0, 0),
          child: new Container(
            color: Color(0xffcec6b0),
            margin: const EdgeInsets.only(top: 50.0, bottom : 80, left: 10, right: 10),
            child: new SingleChildScrollView(
              child: new ConstrainedBox(
                constraints: BoxConstraints(),
                  child: Wrap(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 0.0, bottom : 15),
                        alignment: Alignment.center,
                        color: Color(0xffc3b091),
                        child: AutoSizeText(
                          "These are your" + "\n" + "emotions!",
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 0.90,
                            fontSize: 65,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      for(int i = 0; i < list.length; i++)
                        wordList(i),
                      SizedBox(height: 30, width: width,child:Container(color: Color(0xffc3b091))),
                      Text(emotionValue, 
                        style: TextStyle(fontSize: 35, fontFamily: 'Comfortaa',), 
                        textAlign: TextAlign.center,)
                    ],
                  ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Tooltip(
                message: "Take photo again", 
                textStyle: TextStyle(fontFamily: "Comfortaa", fontSize: 15),
                child:  FloatingActionButton(
                  heroTag: "addPhoto",
                  child: Icon(Icons.add_a_photo, size: 20,),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          CameraScreen(camera: firstCamera, existingList: null),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: width / 8.6,),
              Tooltip(
                message: "Get Movies", 
                textStyle: TextStyle(fontFamily: "Comfortaa", fontSize: 15),
                child:  FloatingActionButton(
                  heroTag: "getResultMovie",
                  child: Icon(Icons.movie, size: 20,),
                  onPressed: () {
                    print(urlMovie);
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          WebViewScreen(url : urlMovie
                                      , existingList: list, urls : urlList),
                      ),
                    );
                  },
                ),
              ),    
              SizedBox(width: width / 8.6,),
              Tooltip(
                message: "Get Music", 
                textStyle: TextStyle(fontFamily: "Comfortaa", fontSize: 15),
                child: FloatingActionButton(
                  heroTag: "getResultMusic",
                  child: Icon(Icons.music_note, size: 20,),
                  onPressed: () {
                    print(urlMusic);
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          WebViewScreen(url : urlMusic
                                      , existingList: list, urls : urlList),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: width / 8.6,),
              Tooltip(
                message: "Get Recipies", 
                textStyle: TextStyle(fontFamily: "Comfortaa", fontSize: 15),
                child: FloatingActionButton(
                  heroTag: "getResultFood",
                  child: Icon(Icons.fastfood, size: 20,),
                  onPressed: () {
                    print(urlFood);
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => 
                          WebViewScreen(url : urlFood
                                      , existingList: list, urls : urlList),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }

  @override
    void dispose() {
      super.dispose();
    }
  
}