import 'package:flutter/material.dart';
import 'placesearch.dart';    
import 'panoram.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: contentBox(context),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: const Color.fromARGB(255, 34, 0, 0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 248, 184, 184).withOpacity(0.8),
          const Color.fromARGB(255, 72, 85, 121).withOpacity(0.8),
        ])
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
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width>500 ? MediaQuery.of(context).size.height* 0.2 : MediaQuery.of(context).size.height* 0.15,
              // width: place.imagesUrls.length * 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: place.imagesUrls.length,
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
                        child: Image.network(
                          place.imagesUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                place.description,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                place.address,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
