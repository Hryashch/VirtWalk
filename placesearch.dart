import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

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

    // try{
    //   getImages();
    // }
    // catch(e){
    //   print(e);
    // }
    
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


// Функция для получения информации о местах через Places API
Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
  // Замените YOUR_API_KEY на ваш ключ API
  String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';
  
  // Отправляем запрос к Places API
  http.Response response = await http.get(Uri.parse(url));

  // Парсим ответ
  Map<String, dynamic> data = json.decode(response.body);
  List<dynamic> results = data['results'];

  // Возвращаем массив с информацией о местах
  return results.cast<Map<String, dynamic>>();
}

// // Функция для получения массива изображений места
// Future<List<String>> getPlaceImages(String placeId) async {
//   // Замените YOUR_API_KEY на ваш ключ API
//   String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';

//   // Отправляем запрос к Places API
//   http.Response response = await http.get(Uri.parse(url));

//   // Парсим ответ
//   Map<String, dynamic> data = json.decode(response.body);
//   List<dynamic> photos = data['result']['photos'];

//   // Формируем массив ссылок на изображения
//   List<String> imageUrls = [];
//   for (var photo in photos) {
//     String photoReference = photo['photo_reference'];
//     String photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&photoreference=$photoReference&key=$apiKey';
//     imageUrls.add(photoUrl);
//   }
//   print(imageUrls.toString());
//   return imageUrls;
// }

