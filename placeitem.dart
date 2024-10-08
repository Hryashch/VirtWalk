
import 'package:flutter/material.dart';
import 'package:virtwalk/placesearch.dart';
import 'panoram.dart';
import 'placeShow.dart';
import 'globals.dart';
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
  @override
  Widget build(BuildContext context) {
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Используйте constraints для доступа к размерам вашего виджета
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double imgSize = width *0.5;
      return Container( 
        margin: const EdgeInsets.all(1),
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
                    showMessage(context, place,(){
                      setState(() {
                        
                      });
                    });
                  },
                  onLongPress: () {
                    if (place.imgs.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PanoramViewScreen(
                            p: place, curImg: 0, mode3d: false,
                          ),
                        ),
                      );
                    } else {
                      
                    }
                  },
                  child:place.imagesUrls.isNotEmpty? 
                    Image.network(place.imagesUrls[0])
                    :place.icon ?? Icon(
                      Icons.error,
                      size: imgSize,
                      color: Colors.red,
                    )
                  ),
                ),
              
            
            const Expanded(child: SizedBox()),
            Center(
              child: GestureDetector(
                onLongPress: () {
                  showMessage(context, place,(){
                    setState(() {
                      
                    });
                  });
                },

                child: RichText(
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                    text: place.name,
                    
                    style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: width *0.1,
                      
                    ),
                  )
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double iconSize = width * 0.13;
                double butSize = width * 0.21;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: butSize,
                      height: butSize,
                      child: IconButton(
                        icon: const Icon(Icons.threed_rotation_rounded),
                        color: place.imagesUrls.isNotEmpty
                            ? Colors.black
                            : const Color.fromARGB(100, 0, 0, 0),
                        tooltip: 'Показать 3D панораму',
                        iconSize: iconSize,
                        onPressed: () {
                          if (place.imgs.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PanoramViewScreen(
                                  p: place, curImg: 0, mode3d: true,
                                ),
                              ),
                            ).then((value) {
                              setState(() {
                                
                              });
                            },);
                          } else {
                            
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: butSize,
                      height: butSize,
                      child: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        tooltip: 'Посмотреть подробности',
                        iconSize: iconSize,
                        onPressed: () {
                          showMessage(context, place,(){
                            setState(() {
                              
                            });
                          });
                        },
                      ),
                    ),
                    !alreadySaved(place.id) ?
                    SizedBox(
                      width: butSize,
                      height: butSize,
                      child: IconButton(
                        icon: const Icon(Icons.turned_in_outlined),
                        tooltip: 'Сохранить в закладки',
                        iconSize: iconSize,
                        onPressed: () async {
                          await saveService.addBookmark(place.place);
                          setState(() {
                          });
                        },
                      ),
                    )
                    :SizedBox(
                      width: butSize,
                      height: butSize,
                      child: IconButton(
                        icon: const Icon(Icons.bookmark_remove),
                        tooltip: 'Удалить из закладок',
                        iconSize: iconSize,
                        onPressed: () async {
                          await saveService.removeBookmark(place.place);
                          setState(() {
                          });
                        },
                      ),
                    ),
                  ],
                );
              }
            )
          ],
          )
        );
      }
    );
  }
}


class PlacesGrid extends StatefulWidget {
  List<dynamic>? ps;

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
        // await place.getImagesWidgets();
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










