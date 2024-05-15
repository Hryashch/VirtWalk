import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'placesearch.dart';
final List <Color> gradColors= [
  Color(0xFFFFC3A0), 
  Color(0xFFFFAFBD).withOpacity(0.5), 
  Color(0xFFFF8EB7).withOpacity(0.5), 
  Color(0xFFFFC58E),
];

final BookmarkService bookmarkService = BookmarkService();
List <String> savedPlacesIds = [];

class FancyTextWidget extends StatelessWidget {
  final String text;

  const FancyTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 25.0,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1.0
                ..color = const Color.fromARGB(255, 58, 50, 50),
              fontWeight: FontWeight.bold,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          text,
          style: GoogleFonts.montserratAlternates(
            textStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              shadows: [
                Shadow(
                  blurRadius: 3.0,
                  color: Theme.of(context).colorScheme.secondary,
                  offset: Offset(3, -1.7),
                ),
              ],
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}




bool alreadySaved(String id){
  return savedPlacesIds.contains(id);
}


class BookmarkService {
  static const _keyBookmarks = 'bookmarks';

  Future<void> clearBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBookmarks);
    savedPlacesIds.clear();
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkStrings = prefs.getStringList(_keyBookmarks);
    if (bookmarkStrings == null) {
      return [];
    }
    return bookmarkStrings.map<Map<String, dynamic>>((json) => jsonDecode(json)).toList();
  }

  Future<void> addBookmark(Map<String, dynamic> place) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> bookmarks = await getBookmarks();
    bookmarks.add(place);
    print(bookmarks.length);
    final bookmarkStrings = bookmarks.map((place) => jsonEncode(place)).toList();
    await prefs.setStringList(_keyBookmarks, bookmarkStrings);
    savedPlacesIds.add(place['place_id']);
  }

  Future<void> removeBookmark(Map<String, dynamic> place) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> bookmarks = await getBookmarks();
    // bookmarks.remove(place);
    bookmarks.removeWhere((bookmark) => bookmark['place_id'] == place['place_id']);
    print(bookmarks.length);
    final bookmarkStrings = bookmarks.map((place) => jsonEncode(place)).toList();
    await prefs.setStringList(_keyBookmarks, bookmarkStrings);
    savedPlacesIds.remove(place['place_id']);
  }
}

