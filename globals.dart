import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'placesearch.dart';

// class SavedSearch{
//   String search;
//   late DateTime DT;
//   SavedSearch(this.search){
//     DT = DateTime.now();
//   }
// }

final List <Color> gradColors= [
  Color(0xFFFFC3A0), 
  Color(0xFFFFAFBD), 
  Color(0xFFFF8EB7), 
  Color(0xFFFFC58E),
];

final SavingService saveService = SavingService();
List <String> savedPlacesIds = [];
// List<SavedSearch> prevSrchs = [];
List <String> prevSrchs = [];



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


class SavingService {
  static const _keyBookmarks = 'bookmarks';
  static const _keyPrevSrchs = 'prevsrchs';
  /*
    надо короче сохранять старые запросы в память до какого-то количества мб
    
    потом для главной страницы сделать красивый виджет где будет написано
    мол вот ваши старые запросы и справа кнопочка мол закрыть
    и дальше ниже ListWheelScrollView.

    Для всего добра пускай будет вон класс выше и массив.
  */

  Future<void> loadStuff()async{
    loadSrchs();
    var ps = await getBookmarks();
    for (int i = 0; i < ps.length;i++){
      savedPlacesIds.add(ps[i]['place_id']);
    }
  }
  Future<void> loadSrchs()async{
    prevSrchs = await getSrches();
  }

  Future<void> clearBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBookmarks);
    savedPlacesIds.clear();
  }
  Future<void> clearPrevSrchs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPrevSrchs);
    prevSrchs.clear();
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkStrings = prefs.getStringList(_keyBookmarks);
    if (bookmarkStrings == null) {
      return [];
    }
    return bookmarkStrings.map<Map<String, dynamic>>((json) => jsonDecode(json)).toList();
  }

  Future<List<String>> getSrches()async{
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookmarkStrings = prefs.getStringList(_keyPrevSrchs);
    if (bookmarkStrings == null) {
      return [];
    }
    return bookmarkStrings;
  }

  Future<void> addBookmark(Map<String, dynamic> place) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> bookmarks = await getBookmarks();
    bookmarks.add(place);
    final bookmarkStrings = bookmarks.map((place) => jsonEncode(place)).toList();
    await prefs.setStringList(_keyBookmarks, bookmarkStrings);
    savedPlacesIds.add(place['place_id']);
  }

  Future<void> addPrevSrch(String srch)async{
    final prefs = await SharedPreferences.getInstance();
    final List<String> srchss = await getSrches();
    if(!srchss.contains(srch)){
      srchss.add(srch);
      await prefs.setStringList(_keyPrevSrchs, srchss);
    }
    loadSrchs();
  }

  Future<void> removeBookmark(Map<String, dynamic> place) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> bookmarks = await getBookmarks();
    bookmarks.removeWhere((bookmark) => bookmark['place_id'] == place['place_id']);
    final bookmarkStrings = bookmarks.map((place) => jsonEncode(place)).toList();
    await prefs.setStringList(_keyBookmarks, bookmarkStrings);
    savedPlacesIds.remove(place['place_id']);
  }
}


