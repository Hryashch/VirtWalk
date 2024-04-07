import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:google_maps_apis/places.dart';


String apiKey = 'AIzaSyCaGIrMBNrDlxzbOnNxj8BvI3uI_MezpLE';

final gplaces = GoogleMapsPlaces(apiKey: apiKey);



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

// Функция для получения массива изображений места
Future<List<String>> getPlaceImages(String placeId) async {
  // Замените YOUR_API_KEY на ваш ключ API
  String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=photos&key=$apiKey';

  // Отправляем запрос к Places API
  http.Response response = await http.get(Uri.parse(url));

  // Парсим ответ
  Map<String, dynamic> data = json.decode(response.body);
  List<dynamic> photos = data['result']['photos'];

  // Формируем массив ссылок на изображения
  List<String> imageUrls = [];
  for (var photo in photos) {
    String photoReference = photo['photo_reference'];
    String photoUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxheight=1000&photoreference=$photoReference&key=$apiKey';
    imageUrls.add(photoUrl);
  }
  print(imageUrls.toString());
  return imageUrls;
}

