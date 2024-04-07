import 'dart:io';

import 'package:flutter/material.dart';
import 'package:virtwalk/placesearch.dart';
import 'panoram.dart';




class PlaceItem extends StatefulWidget {
  late String placeName;
  late String imageURL;
  late dynamic p;
  late dynamic img;
  late List<dynamic> photos;
  PlaceItem(String name){
    placeName = name;
    imageURL = '';
  }

  PlaceItem.fromPlace(dynamic pl){
    placeName = pl['name'];
    p =pl;
    _getImg();

  }

  Future<void> _getImg()async {
    photos = await getPhotosForPlace(p);
    img = photos[0];
  }

  @override
  State<PlaceItem> createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 200,
        minHeight: 130,
        maxHeight: 150,
        maxWidth: 300
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
          Image.file(
            widget.img,
            fit: BoxFit.cover,
            width: 130,
            height: 130,
          ),
          
          // Image(
          //   image: widget.img,
          //   //image: AssetImage(this.widget.imageURL),
          //   // width: 100,
          //   // height: 100,
          //   // errorBuilder: (context, error, stackTrace) {
          //   //   return const Icon(
          //   //     Icons.error,
          //   //     color: Color.fromARGB(255, 255, 85, 73),
          //   //     size: 70,
          //   //   );
          //   // },
          // ),
          // SizedBox(
          //   height: 1,
          // ),
          Center(
            child: RichText(
              softWrap: false,
              maxLines: 1,
              text: TextSpan(
                text: this.widget.placeName,
                style: const TextStyle(
                  color: Color(0xff222222)
                ),
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
  String name=''; 
  List <dynamic>? ps;

  PlacesGrid({required this.name}); 

  PlacesGrid.fromPlace({required this.ps});

  @override
  State<PlacesGrid> createState() => _PlacesGridState();
}

class _PlacesGridState extends State<PlacesGrid> {
  @override
  Widget build(BuildContext context) {
    int itemCount;
    if (widget.ps != null && widget.ps!.isNotEmpty) {
      itemCount = widget.ps!.length;
    } else {
      itemCount = 60;
    }

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 600
      ),
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, 
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          try{
            return PlaceItem.fromPlace(widget.ps![index]);
          }
          catch(e){
            print('AAAAAAAAAAAAAAAAAAAAAAAA $e \n ${widget.ps![index]}');
            return PlaceItem(widget.name);
          }
          
        },
        itemCount: itemCount,
      ),
    );
  }
}