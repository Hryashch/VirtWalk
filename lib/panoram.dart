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

  late PanoramaViewer pan;
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
    pic = Image.network(
      widget.p.imagesUrls[curImg],
      fit: BoxFit.contain,
      // fit: BoxFit.cover,  
    );
    widShow = mode3d? PanoramaViewer(
      child: pic,  
    ) : 
    Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.p.imagesUrls[curImg]),
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
        pic
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
        title: const Center(
          child: Text('VirtWalker')
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
                    icon: Icon(mode3d ?  Icons.image : Icons.threed_rotation_rounded ),
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
                    color: Colors.black,
                    icon: const Icon(Icons.remove_red_eye_sharp),
                    tooltip: 'Больше информации',
                    onPressed: () {
                      showMessage(context, widget.p);
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
                    onPressed: (){
                      curImg --;
                      if(curImg <=-1){
                        curImg = widget.p.imagesUrls.length-1;
                      }
                      updateStuff();
                    },
                    icon: Icon(Icons.arrow_circle_left_outlined)
                  ),
                  IconButton(
                    onPressed: (){
                      curImg ++;
                      if(curImg >= widget.p.imagesUrls.length){
                        curImg = 0;
                      }
                      updateStuff();
                    },
                    icon: Icon(Icons.arrow_circle_right_outlined),
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