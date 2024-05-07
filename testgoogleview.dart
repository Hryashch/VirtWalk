
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<Uint8List> getStreetViewImage(String apiKey, double latitude, double longitude, {String size = "600x300"}) async {
//   final apiUrl = "https://maps.googleapis.com/maps/api/streetview";
//   final response = await http.get(Uri.parse(
//       "$apiUrl?size=$size&location=$latitude,$longitude&key=$apiKey"));
//   if (response.statusCode == 200) {
//     return response.bodyBytes;
//   } else {
//     throw Exception('Failed to load image');
//   }
// }


// class gottenImage extends StatefulWidget {
  

//   @override
//   State<gottenImage> createState() => _gottenImageState();
// }

// class _gottenImageState extends State<gottenImage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<Uint8List>(
//         future: getStreetViewImage(
//           "AIzaSyCaGIrMBNrDlxzbOnNxj8BvI3uI_MezpLE",
//           37.7749, // Широта (например, для Сан-Франциско)
//           -122.4194, // Долгота (например, для Сан-Франциско)
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Image.memory(snapshot.data!);
//           }
//         },
//       ),
//     );
//   }
  
// }