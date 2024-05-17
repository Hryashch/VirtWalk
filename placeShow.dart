import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'placesearch.dart';    
import 'panoram.dart';

import 'package:flutter/services.dart';
import 'globals.dart';

void showMessage(context, Place place,VoidCallback onDialogClosed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PlacePopupWidget(place: place);
    },
  ).then((value) {
    onDialogClosed();

  },);
}

class PlacePopupWidget extends StatefulWidget {
  final Place place;

  const PlacePopupWidget({Key? key, required this.place}) : super(key: key);

  @override
  _PlacePopupWidgetState createState() => _PlacePopupWidgetState();
}

class _PlacePopupWidgetState extends State<PlacePopupWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                !alreadySaved(widget.place.id)
                    ? IconButton(
                        icon: const Icon(Icons.turned_in_outlined),
                        tooltip: 'Сохранить в закладки',
                        onPressed: () async {
                          await saveService.addBookmark(widget.place.place);
                          setState(() {
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.bookmark_remove),
                        tooltip: 'Удалить из закладок',
                        onPressed: () async {
                          await saveService.removeBookmark(widget.place.place);
                          setState(() {
                          });
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
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        gradient: LinearGradient(
          colors: gradColors,
          end: Alignment.bottomRight,
          begin: Alignment.topLeft,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.place.name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width > 500 ? 26.0 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            if (widget.place.imgs.isNotEmpty) 
              SizedBox(
                height: MediaQuery.of(context).size.width > 500
                    ? MediaQuery.of(context).size.height * 0.2
                    : MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.place.imgs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 3.0,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PanoramViewScreen(
                                  p: widget.place,
                                  curImg: index,
                                  mode3d: false,
                                ),
                              ),
                            );
                          },
                          child: widget.place.imgs[index],
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
                  Clipboard.setData(ClipboardData(text: widget.place.address));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Адрес скопирован в буфер обмена'),
                  ));
                },
                child: Text(
                  widget.place.address,
                  style: const TextStyle(
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
