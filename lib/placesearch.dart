import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';

// import 'package:google_maps_apis/places.dart';
//final gplaces = GoogleMapsPlaces(apiKey: apiKey);

String apiKey = 'AIzaSyCaGIrMBNrDlxzbOnNxj8BvI3uI_MezpLE';


class Place {
  late Map<String, dynamic> place;
  late final String name;
  late final String address;
  late var imagesUrls = <String>[];
  late final String description;
  late final String id;

  Place({
    required this.place
  }){
    name = place.containsKey('name') ? place['name'] : '';
    address = place.containsKey('formatted_address') ? place['formatted_address'] : '';
    id = place.containsKey('place_id') ? place['place_id'] : '';
  }
  
  Future<void> getImages() async {
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&fields=photos&key=$apiKey';

    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> photos = data['result']['photos'];
    List<String> imagesUrls = [];
    for (var photo in photos) {
      String photoReference = photo['photo_reference'];
      String photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&photoreference=$photoReference&key=$apiKey';
      imagesUrls.add(photoUrl);
    }
    this.imagesUrls = imagesUrls;
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
  String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';
  if (nextPageToken != null) {
    url += '&pagetoken=$nextPageToken';
  }

  http.Response response = await http.get(Uri.parse(url));
  Map<String, dynamic> data = json.decode(response.body);
  print(data.keys);
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