import 'package:flutter/material.dart';
import 'panoram.dart';

class PlaceItem extends StatefulWidget {
  late String placeName;
  late String imageURL;

  PlaceItem(String name){
    placeName = name;
    imageURL = '';
  }

  @override
  State<PlaceItem> createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 130,
        maxWidth: 100
      ),
      // width: 130,
      // height: 130,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Image(
            image: AssetImage(this.widget.imageURL),
            // width: 100,
            // height: 100,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                color: Color.fromARGB(255, 255, 85, 73),
                size: 70,
              );
            },
          ),
          // SizedBox(
          //   height: 1,
          // ),
          Center(
            child: RichText(
              softWrap: false,
              maxLines: 1,
              text: TextSpan(
                text: this.widget.placeName
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.threed_rotation_rounded),
                tooltip: 'Показать 3D панораму',
                onPressed: () {
                  //setState(){};
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PanoramViewScreen())
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_red_eye),
                tooltip: 'Посмотреть подробности',
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.turned_in_outlined),
                tooltip: 'Сохранить в закладки',
                onPressed: () {},
              ),
            ],
          )
        ],
        )
    );
  }
}




class PlacesGrid extends StatefulWidget {
  final String name; 

  PlacesGrid({required this.name}); 

  @override
  State<PlacesGrid> createState() => _PlacesGridState();
}

class _PlacesGridState extends State<PlacesGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, 
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: 60, 
        itemBuilder: (BuildContext context, int index) {
          return PlaceItem(widget.name);
        },
      ),
    );
  }
}