
import 'package:flutter/material.dart';
import 'package:virtwalk/placesearch.dart';
import 'panoram.dart';

class PlaceItem extends StatefulWidget {
  final Map<String,dynamic> p;
  dynamic img = const Icon(
      Icons.error,
      color: Color.fromARGB(255, 255, 85, 73),
      size: 70,
    );

  PlaceItem({required this.p});


  @override
  State<PlaceItem> createState() => _PlaceItemState();
}

class _PlaceItemState extends State<PlaceItem> {

  List<String> photos=[];
  String imageURL = '';
  String placeName = '';
  String placeAdress = '';
  @override
  initState() {
    super.initState();
    getStuff();  
  }
  Future<void> getStuff() async {
    try{
      Map<String, dynamic> place = widget.p;
      placeName = place['name'];
      placeAdress = place['formatted_address'];

    // Если место содержит place_id, получаем фотографии
    if (place.containsKey('place_id')) {
      String placeId = place['place_id'];
      List<String> fetchedPhotos = await getPlaceImages(placeId);
      setState(() {
        photos = fetchedPhotos;
      });
    }

      //widget.photos = await getPlaceImages(widget.p['place_id']);
      if(photos.isNotEmpty) {
        imageURL = photos[0];
      }
    }
    catch(e){
      print(e);
    }
  }
  void _showAdress(context){
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$placeName'),
        content: Text('$placeAdress'),
        
        actions: <Widget>[
          TextButton(
            child: const Text('Ок'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

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
          const SizedBox(
            height: 10,
          ),
         
          if(imageURL !='')
            Image.network(imageURL, height: 70,)
          else
            widget.img,
         
          Expanded(child: SizedBox()),
          Center(
            child: RichText(
              softWrap: false,
              maxLines: 1,
              text: TextSpan(
                text: placeName,
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
                    MaterialPageRoute(builder: (context) => PanoramViewScreen(panUrl: imageURL,))
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_red_eye),
                tooltip: 'Посмотреть подробности',
                onPressed: () {
                  _showAdress(context);
                },
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
            //return PlaceInfoWidget(place: widget.ps![index]);
            return PlaceItem(p: widget.ps![index]);
          }
          catch(e){
            print('AAAAAAAAAAAAAAAAAAAAAAAA $e \n ${widget.ps![index]}');
            // return PlaceItem(widget.name);
          }
          
        },
        itemCount: itemCount,
      ),
    );
  }
}












