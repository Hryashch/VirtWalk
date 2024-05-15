import 'package:flutter/material.dart';
import 'package:virtwalk/main.dart';
import 'placesearch.dart';
import 'globals.dart';
import 'placeitem.dart';  

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late List<dynamic> _bookmarks = [];
  bool showGrid = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    print('i');
  }

  Future<void> _loadBookmarks() async {
    try {
      var bookmarks = await bookmarkService.getBookmarks();
      setState(() {
        _bookmarks = bookmarks.map((bookmark) => bookmark).toList();
        print(_bookmarks.length);
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      showGrid = false;
    });
    setState(() {
      showGrid = _bookmarks.isNotEmpty;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradColors.sublist(2),
            )
          ),
        ),
        title: 
            const FancyTextWidget(text: 'Закладки') ,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },

        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarksPage(),
                ),
              );
             
            },
            icon: const Icon(
              Icons.replay_rounded
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !showGrid
                  ? Center(
                    child: Column(
                      children: [
                        RichText(
                          text:const TextSpan(
                            text: 'нет сохраненных закладок',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 18, 
                              letterSpacing: 1,
                              color: Colors.black,   
                            )
                          ),
                        ),
                        const Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 50,
                          )
                      ],
                    ),
                  )
                  : Expanded(
                    child: PlacesGrid.fromPlace(ps: _bookmarks)
                  ),
                  if(showGrid)
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                        elevation: WidgetStateProperty.all(0),
                        shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          side: BorderSide(
                            color: Color(0xFF000000),
                            width: 1.5,
                          ),
                        )),
                      ),
                      onPressed: () {
                        bookmarkService.clearBookmarks();
                        showGrid = false;
                        setState(() {
                        });
                      }, 
                      child: RichText(
                        text:const TextSpan(
                          text: 'удалить все закладки',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
