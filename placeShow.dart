import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'placesearch.dart';    
import 'panoram.dart';

import 'package:flutter/services.dart';
import 'globals.dart';
void showMessage(context,Place place){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PlacePopupWidget(place: place);
    },
  );
}


class PlacePopupWidget extends StatelessWidget {
  final Place place;

  const PlacePopupWidget({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.2),
            child: contentBox(context),
          ),
          Positioned(
            // top: 3,
            right: 5,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 34, 0, 0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                !alreadySaved(place.id) ?
                  IconButton(
                    icon: const Icon(Icons.turned_in_outlined),
                    tooltip: 'Сохранить в закладки',
                    onPressed: () async {
                      await bookmarkService.addBookmark(place.place);
                    },
                  )
                  :IconButton(
                    icon: const Icon(Icons.bookmark_remove),
                    tooltip: 'Удалить из закладок',
                    onPressed: () async {
                      await bookmarkService.removeBookmark(place.place);
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget contentBox(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 700
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(colors: gradColors,
        
        end: Alignment.bottomRight,
        begin: Alignment.topLeft,
      
        )
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                place.name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width>500 ? 26.0: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10,),
            if(place.imgs.isNotEmpty) 
            SizedBox(
              height: MediaQuery.of(context).size.width>500 ? MediaQuery.of(context).size.height* 0.2 : MediaQuery.of(context).size.height* 0.15,
              // width: place.imagesUrls.length * 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: place.imgs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 3.0,
                        )
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PanoramViewScreen(
                              p: place, curImg: index, mode3d: false,
                            ),
                          ),
                        );
                        },
                        child: place.imgs[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: place.address));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Адрес скопирован в буфер обмена'),
                  ));
                },
                child: Text(
                  place.address,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
