import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:google_maps_apis/places.dart';


String apiKey = 'AIzaSyCaGIrMBNrDlxzbOnNxj8BvI3uI_MezpLE';

final gplaces = GoogleMapsPlaces(apiKey: apiKey);

// Future<List<dynamic>> fetchSearchResults(String query, String apiKey, String cx) async {
//   final response = await http.get(Uri.parse('https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$cx&q=$query'));
//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     // Если запрос прошел успешно, декодируем ответ JSON
//     Map<String, dynamic> data = jsonDecode(response.body);
//     // Возвращаем результаты поиска
//     print(data['items']);
//     return data['items'];
//   } else {
//     // Если запрос не удался, выбрасываем исключение
//     throw Exception('Failed to load search results');
//   }
// }






// Future<List<dynamic>> fetchPlacesSearch(String apiKey) async {
//   final response = await http.get(Uri.parse('https://places.googleapis.com/v1/places/ChIJ2fzCmcW7j4AR2JzfXBBoh6E/photos/AUacShh3_Dd8yvV2JZMtNjjbbSbFhSv-0VmUN-uasQ2Oj00XB63irPTks0-A_1rMNfdTunoOVZfVOExRRBNrupUf8TY4Kw5iQNQgf2rwcaM8hXNQg7KDyvMR5B-HzoCE1mwy2ba9yxvmtiJrdV-xBgO8c5iJL65BCd0slyI1/media?maxHeightPx=400&maxWidthPx=400&key=$apiKey'));
//   print(response.statusCode);
//   if (response.statusCode == 200) {
//     // Если запрос прошел успешно, декодируем ответ JSON
//     Map<String, dynamic> data = jsonDecode(response.body);
//     // Возвращаем результаты поиска
//     print(data['items']);
//     return data['items'];
//   } else {
//     // Если запрос не удался, выбрасываем исключение
//     throw Exception('Failed to load search results');
//   }
// }

Future<List<dynamic>> getSearchResults(String query) async {
  final searchUrl = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';
  print(searchUrl);
  try {
    final searchResponse = await http.get(Uri.parse(searchUrl));
    final searchData = json.decode(searchResponse.body);

    if (searchData['status'] == 'OK') {
      final results = searchData['results'];
      return results;
    }
  } catch (e) {
    print(e);
  }
  return [];
}

Future<List<dynamic>> getPhotosForPlace(dynamic place) async {
  final placeId = place['place_id'];
          final placeName = place['name'];

          // Получение фотографии места
          final photoReference = place['photos'][0]['photo_reference'];
          // final photoUrl =
          //     'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
          final photoUrl = 'https://places.googleapis.com/v1/$placeName/media?key=$apiKey&maxHeightPx=400&maxWidthPx=400';
          
          print('\n$photoReference\n');
          try{
            String url = gplaces.buildPhotoUrl(photoReference: photoReference, maxHeight: 400, maxWidth: 400);
            return [Image.network(url)];
            //вылет без причины на этой строчке
            // final photo = await http.get(Uri.parse(url));
            //final photoResponse = await http.get(Uri.parse(photoUrl));
            // if (photo.statusCode == 200) {
            //   final bytes = photo.bodyBytes;
            //   final file = File('${placeName}_photo.jpg');
            //   await file.writeAsBytes(bytes);
            //   return [file];
            // }
          }
          catch(e){
            print(e);
            return [const Icon(
                Icons.error,
                color: Color.fromARGB(255, 255, 85, 73),
                size: 70,
              )];

          }
          return [];
}

Future<void> searchPlacesAndPhotos(String query) async {
    
    final searchUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$apiKey';

    try {
      final searchResponse = await http.get(Uri.parse(searchUrl));
      final searchData = json.decode(searchResponse.body);

      if (searchData['status'] == 'OK') {
        final results = searchData['results'] as List<dynamic>;

        for (var place in results) {
          final placeId = place['place_id'];
          final placeName = place['name'];

          // Получение фотографии места
          final photoReference = place['photos'][0]['photo_reference'];
          final photoUrl =
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';

          final photoResponse = await http.get(Uri.parse(photoUrl));
          if (photoResponse.statusCode == 200) {
            final bytes = photoResponse.bodyBytes;
            final file = File('${placeName}_photo.jpg');
            await file.writeAsBytes(bytes);
            print('Фотография места "$placeName" сохранена.');
          } else {
            print('Не удалось получить фотографию места "$placeName".');
          }
        }
      } else {
        print('Не удалось выполнить поиск мест.');
      }
    } catch (e) {
      print('Произошла ошибка: $e');
    }
  }
  