import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:panorama/panorama.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'placeShow.dart';
import 'placesearch.dart';    

//import 'testgoogleview.dart';


class PanoramViewScreen extends StatefulWidget {
  late Place p;
  late bool mode3d;
  late int curImg;
  PanoramViewScreen({required this.p,required this.curImg, required this.mode3d});
  @override
  PanoramViewScreenState createState() => PanoramViewScreenState();
}

class PanoramViewScreenState extends State<PanoramViewScreen> {
  late Color cTheme;
  // late final String panoramURL;
  // late Image panoram;
  late bool mode3d;
  late int curImg;
  late Key _panoramaKey = UniqueKey();
  late Image pic;
  late dynamic widShow;

  // late PanoramaViewer pan;
  @override
  void initState() {
    curImg = widget.curImg;
    mode3d = widget.mode3d;
    super.initState();
    // panoramURL = widget.p.imagesUrls[curImg];
    cTheme = const Color.fromARGB(255, 246, 145, 114);
    // pic = Image.network(widget.p.imagesUrls[curImg]);
    // panoram = Image.network(panoramURL);
    updateStuff();
  }
  @override
  void dispose() {
    super.dispose();
  }
  void updateStuff(){
    double? xStart;
    double? xEnd;
    ImageProvider<Object> imageProvider = widget.p.imgs[curImg].image; 
    pic = Image(
      image:imageProvider,
      fit: BoxFit.contain,
    
    );
    // pic = Image.network(
    //   widget.p.imagesUrls[curImg],
    //   fit: BoxFit.contain,
    //   // fit: BoxFit.cover,  
    // );
    widShow = mode3d? PanoramaViewer(
      sensitivity: 3,
      animSpeed: 1,
      child: pic,  
    ) : 
    Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: NetworkImage(widget.p.imagesUrls[0]),
              image: imageProvider,
              fit:  BoxFit.cover
            )
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10.0,
            sigmaY: 10.0,
          ),
          child: Container(
            color: Colors.black.withOpacity(0.5), 
          ),
        ),
        // pic
        GestureDetector(
          child: pic,
          onDoubleTap: () {
            mode3d = !mode3d;
            updateStuff();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PanoramViewScreen(
                  p: widget.p, curImg: curImg, mode3d: true,
                ),
              ),
            );
          },
          onHorizontalDragStart: (details) {
            xStart = details.globalPosition.dx;
          },
          onHorizontalDragUpdate: (details) {
            xEnd = details.globalPosition.dx;
          },
          onHorizontalDragEnd: (details) {
            try{if((xEnd! - xStart!).abs()>30){
              if(xEnd! - xStart! > 0){
                curImg--;
                if(curImg <= -1){
                  curImg = widget.p.imgs.length-1;
                }
              }else{
                curImg++;
                if(curImg >= widget.p.imgs.length){
                  curImg = 0;
                }
              }
              updateStuff();
            }}
            catch(e){
              // print(e);
            }
          },
        )
      ],
    )
    ;
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(widget.p.name)
          ),
        backgroundColor: cTheme.withAlpha(240),
        actions: [
          IconButton(
            tooltip: 'Открыть настройки',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              //updateColor();
            },
          ),
        ],
      ),
      body: Stack(
        children:[
          Center(
            child: widShow,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              height: 50,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: cTheme.withAlpha(120),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(30)     
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    color: Colors.black,
                    icon: Icon(mode3d ?  Icons.image : Icons.threed_rotation ),
                    tooltip: 'переключить режим',
                    onPressed: () {
                      mode3d = !mode3d;
                      updateStuff();
                      if(mode3d){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PanoramViewScreen(
                              p: widget.p, curImg: curImg, mode3d: true,
                            ),
                          ),
                        );
                      }
                      
                    },
                  ),
                  IconButton(
                    tooltip: 'Cохранить в закладки',
                    color: Colors.black,
                    onPressed: (){

                    },
                    icon: const Icon(Icons.turned_in_outlined),
                  ),
                  IconButton(
                    color: Colors.black,
                    iconSize: 30,
                    icon: const Icon(Icons.remove_red_eye),
                    tooltip: 'Больше информации',
                    onPressed: () {
                      showMessage(context, widget.p);
                    },
                  ),
                  if(widget.p.imgs.length > 1)  
                  IconButton(
                    color: Colors.black,
                    onPressed: (){
                      curImg --;
                      if(curImg <=-1){
                        curImg = widget.p.imgs.length-1;
                      }
                      updateStuff();
                    },
                    icon: Icon(Icons.arrow_circle_left)
                  ),
                  if(widget.p.imgs.length > 1)
                  IconButton(
                    color: Colors.black,
                    onPressed: (){
                      curImg ++;
                      if(curImg >= widget.p.imgs.length){
                        curImg = 0;
                      }
                      updateStuff();
                    },
                    icon: Icon(Icons.arrow_circle_right),
                    )    
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}






