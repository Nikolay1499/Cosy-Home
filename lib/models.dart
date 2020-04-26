class Responses{
  List<FaceAnnotations> responses;

  Responses({this.responses});

  factory Responses.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['responses'] as List;
    if(!list[0].toString().contains("faceAnnotations:"))
      return null;
    List<FaceAnnotations> responses = list.map((i) => FaceAnnotations.fromJson(i)).toList();

    return Responses(responses: responses);
  }
}

class FaceAnnotations{
  List<Likelihood> faceAnnotations;

  FaceAnnotations({this.faceAnnotations});

  factory FaceAnnotations.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['faceAnnotations'] as List;
    List<Likelihood> faceAnnotations = list.map((i) => Likelihood.fromJson(i)).toList();


    return FaceAnnotations(
        faceAnnotations: faceAnnotations
    );
  }
}

class Likelihood{
  List<String> emotions;

  Likelihood({this.emotions});

  factory Likelihood.fromJson(Map<String, dynamic> parsedJson){
    var emotions = new List<String>(4);
    emotions[0] = parsedJson['angerLikelihood'];
    emotions[1] = parsedJson['joyLikelihood'];
    emotions[2] = parsedJson['sorrowLikelihood'];
    emotions[3] = parsedJson['surpriseLikelihood'];
    return Likelihood(
        emotions: emotions,
    );
  }

}