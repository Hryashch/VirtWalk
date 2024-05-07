import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:structures/structures.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'panorampainter.dart';
// import 'dart:io';

// import 'package:google_maps_apis/places.dart';
//final gplaces = GoogleMapsPlaces(apiKey: apiKey);

String apiKey = 'AIzaSyCaGIrMBNrDlxzbOnNxj8BvI3uI_MezpLE';


class Place {
  late Map<String, dynamic> place;
  late final String name;
  late final String address;
  late var imagesUrls = <String>[];
  // late final String description;
  late final String id;
  late Pair<double, double> coords;
  late Image? icon;

  late Image streetPan;

  late var imgs = <Image>[];

  Place({
    required this.place
  }){
    // // print(place.toString());
    // print(place.entries.toString());
    // print(place['geometry']['location']);
    coords = Pair(place['geometry']['location']['lat'], place['geometry']['location']['lng']);
    name = place.containsKey('name') ? place['name'] : '';
    address = place.containsKey('formatted_address') ? place['formatted_address'] : '';
    id = place.containsKey('place_id') ? place['place_id'] : '';
    // description = place.containsKey('formatted_phone_number') ? place['formatted_phone_number'] : 'no description';
    icon = place.containsKey('icon') ? Image.network(place['icon']) : null;
  }

  Future <void> getStreetView()async{
    // print('${coords.first},${coords.second}');
    List<String> imgsUrls = [];
    for(int i = 0; i< 360; i+= 120){
      String url = 'https://maps.googleapis.com/maps/api/streetview?size=800x800&location=${coords.first},${coords.second}&fov=120&heading=$i&pitch=0&key=$apiKey';
      imgsUrls.add(url);
    }
    // print(imgsUrls.length); 
    // imgs.add(CombinedImage(imgsUrls) as Image);
    try{
      streetPan = await mergeImages(imgsUrls);
      imgs.insert(0,streetPan);
      print('good');
    }
    catch(e){
      print(e);
    }
    // print('heh');
    // String url = 'https://maps.googleapis.com/maps/api/streetview?size=3800x1400&location=${coords.first},${coords.second}&fov=90&heading=0&pitch=0&key=$apiKey';
    // // print(url);
    // http.Response res = await http.get(Uri.parse(url));
    // // print(res.body.toString());
    // imagesUrls.add(url);
  }

  
  Future<void> getImages() async {
    getStreetView();
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&fields=photos&key=$apiKey';
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> photos = data['result']['photos'];
    // List<String> imagesUrls = [];
    for (var photo in photos) {
      String photoReference = photo['photo_reference'];
      String photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&photoreference=$photoReference&key=$apiKey';
      imagesUrls.add(photoUrl);
    }
    // this.imagesUrls = imagesUrls;
    await getImagesWidgets();
    
  }


  Future<void> getImagesWidgets() async{
    for(int i = 0; i < imagesUrls.length; i++) {
      imgs.add(
        Image.network(
          imagesUrls[i],
          fit: BoxFit.cover,
        )
      );
    }
  }
}


// Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
//   String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';
  
//   http.Response response = await http.get(Uri.parse(url));
//   Map<String, dynamic> data = json.decode(response.body);
//   List<dynamic> results = data['results'];
//   return results.cast<Map<String, dynamic>>();
// }
Future<List<Map<String, dynamic>>> searchPlaces(String query, {String? nextPageToken}) async {
  String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&language=ru&key=$apiKey';
  if (nextPageToken != null) {
    url += '&pagetoken=$nextPageToken';
  }

  http.Response response = await http.get(Uri.parse(url));
  Map<String, dynamic> data = json.decode(response.body);
  // print(data.keys);
  // print(data['results'].toString());
  List<dynamic> results = data['results'];

  // if (data.containsKey('next_page_token')) {
  //   String nextPageToken = data['next_page_token'];
  //   // Ждём некоторое время, чтобы Google обработал запрос и получил следующую страницу
  //   await Future.delayed(Duration(seconds: 2));
  //   // Рекурсивно вызываем searchPlaces для получения следующей страницы результатов
  //   List<Map<String, dynamic>> nextPageResults = await searchPlaces(query, nextPageToken: nextPageToken);
  //   // Добавляем результаты из следующей страницы к общему списку результатов
  //   results.addAll(nextPageResults);
  // }

  return results.cast<Map<String, dynamic>>();
}