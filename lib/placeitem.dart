
import 'package:flutter/material.dart';
import 'package:virtwalk/placesearch.dart';
import 'panoram.dart';

class PlaceItem extends StatefulWidget {
  final Place p;
  

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
    double imgSize = MediaQuery.sizeOf(context).width > 600 ? 70 
                : MediaQuery.sizeOf(context).width > 444 ? MediaQuery.sizeOf(context).width/10 
                : MediaQuery.sizeOf(context).width/5;
    return Container(
      
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), 
          ),
        ],
      ),
      child: Column(
        children: [
          const Expanded(child: SizedBox()),
         
            Container(
              constraints: BoxConstraints(
                maxHeight: imgSize,
              ),
              child: GestureDetector(
                onTap: (){
                  _showMessage(context, place.address);
                },
                child:place.imagesUrls.isNotEmpty? 
                  Image.network(place.imagesUrls[0])
                  : Icon(
                    Icons.error,
                    size: imgSize,
                    color: Colors.red,
                  )
                ),
              ),
            
         
          const Expanded(child: SizedBox()),
          Center(
            child: RichText(
              softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.fade,
              text: TextSpan(
                text: place.name,
                
                style: TextStyle(
                  color: Color(0xff222222),
                  fontSize: MediaQuery.sizeOf(context).width > 600 ? 20 : MediaQuery.sizeOf(context).width/25,
                  
                ),
              )
            ),
          ),
          if( MediaQuery.sizeOf(context).width > 510 || MediaQuery.sizeOf(context).width<440 && MediaQuery.sizeOf(context).width > 365)
          LayoutBuilder(
            builder: (context, constraints) {
              final iconSize = constraints.maxWidth / 8;
              MainAxisAlignment alig = iconSize < 30 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center;
              return Row(
                mainAxisAlignment: alig,
                children: [
                  //if(place.imagesUrls.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.threed_rotation_rounded),
                    color: place.imagesUrls.isNotEmpty
                        ? Colors.black
                        : const Color.fromARGB(100, 0, 0, 0),
                    tooltip: 'Показать 3D панораму',
                    iconSize: iconSize,
                    onPressed: () {
                      if (place.imagesUrls.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PanoramViewScreen(
                              panUrl: place.imagesUrls[0],
                            ),
                          ),
                        );
                      } else {
                        _showMessage(context, 'Не удалось найти панораму');
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    tooltip: 'Посмотреть подробности',
                    iconSize: iconSize,
                    onPressed: () {
                      _showMessage(context, place.address);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.turned_in_outlined),
                    tooltip: 'Сохранить в закладки',
                    iconSize: iconSize,
                    onPressed: () {},
                  ),
                ],
              );
            }
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
        await place.getImages().timeout(const Duration(seconds: 3));
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
    // final double plsInRow = MediaQuery.sizeOf(context).width > 600 ? 3 : 2;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 600
      ),
      padding: const EdgeInsets.all(1.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          // crossAxisCount: 3,
          // crossAxisCount: plsInRow, 
          maxCrossAxisExtent: 200,
          // childAspectRatio: 10.5,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
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










