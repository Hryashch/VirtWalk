
import 'package:flutter/material.dart';
import 'package:virtwalk/placesearch.dart';
import 'panoram.dart';

class PlaceItem extends StatefulWidget {
  final Place p;
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
  late Place place;
  
  @override
  initState() {
    super.initState();
    setState(() {
      place = widget.p;
      //load();
    });
  }
  // Future<void> load()async{
  //   await place.getImages();
  // }
  void _showMessage(context,String message){
  showDialog(
    context: context,
    builder: (context) {
      final dialogHeight = MediaQuery.of(context).size.height * 0.05;
      return AlertDialog(
        title: Text('${place.name}'),
        content: Container(
          height: dialogHeight,
          child: Column(
            children: [
          
              Text('$message'),
            ],
          ),
        ),
        
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
         
          if(place.imagesUrls.isNotEmpty) 
            Image.network(place.imagesUrls[0], height: 70,)
          else
            widget.img,
         
          Expanded(child: SizedBox()),
          Center(
            child: RichText(
              softWrap: false,
              maxLines: 1,
              text: TextSpan(
                text: place.name,
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
                  if(place.imagesUrls.isNotEmpty){  
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => PanoramViewScreen(panUrl: place.imagesUrls[0],))
                    );
                  }
                  else{
                    _showMessage(context, 'Не удалось найти панораму');
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_red_eye),
                tooltip: 'Посмотреть подробности',
                onPressed: () {
                  _showMessage(context, place.address);
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
  List<dynamic>? ps;

  PlacesGrid({required this.name}); 

  PlacesGrid.fromPlace({required this.ps});

  @override
  State<PlacesGrid> createState() => _PlacesGridState();
}

class _PlacesGridState extends State<PlacesGrid> {
  List<Place> places = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    // Загружаем данные и создаем объекты Place только после полной загрузки данных
    loadPlaces();
  }

  void loadPlaces() async {
    loading = true;
    List<Place> loadedPlaces = [];
    for (var placeData in widget.ps!) {
      Place place = Place(place: placeData);
      try{
        await place.getImages().timeout(const Duration(seconds: 1));
      }
      catch(e){}
      loadedPlaces.add(place);
      setState(() {
        places = loadedPlaces;
      });
    }
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
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
          if (index < places.length) {
            return PlaceItem(p: places[index]);
          } else {
            return const Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator()), 
                Text(
                  'Загрузка...', 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.black, 
                  ),
                ),
              ],
            );
          }
        },
        itemCount: places.length + (loading ? 1 : 0), // Учитываем индикатор загрузки
      ),
    );
  }
}










