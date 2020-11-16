import 'package:customerapp/models/location.dart';

class RestaurantDTO {
  int id;
  String name;
  String imgPath;
  Location location;

  RestaurantDTO({this.id, this.name, this.imgPath, this.location});

  factory RestaurantDTO.fromJson(Map<String, dynamic> json) {
    return RestaurantDTO(
        id: (json.containsKey('id')) ? json['id'] : null,
        name: json['name'],
        imgPath: (json.containsKey('imgPath')) ? json['imgPath'] : null,
        //Dummy location
        location: new Location(40, 2.1));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> toReturn = {'id': id, 'name': name};
    if (imgPath != null) toReturn['imgPath'] = imgPath;
    //Add location when it's implemented
    return toReturn;
  }
}
