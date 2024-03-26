import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:panorama/panorama.dart';



class PanoramViewScreen extends StatefulWidget {
  PanoramViewScreen();
  @override
  PanoramViewScreenState createState() => PanoramViewScreenState();
}

class PanoramViewScreenState extends State<PanoramViewScreen> {
  late Color cTheme;
  late String panoramURL;
  late Image panoram;
  @override
  void initState() {
    super.initState();
    print('initState');
    cTheme = const Color.fromARGB(255, 246, 145, 114);
    panoramURL = 'https://static.dermandar.com/php/getimage.php?epid=clmJly&equi=1&w=1024&h=512';
    panoram = Image.network(panoramURL);
  }
  @override
  void dispose() {
    super.dispose();
    print('dispose');
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
            child: Container(
              child:
              Center(
                child: Image.network(panoramURL),
              ),
              // child: Panorama(
              //   //child: Image.asset('assets/p.jpg'),
              //   animSpeed: 2,
              //   sensitivity: 1,        
              //   onTap: (longitude, latitude, tilt) {
              //     print(this.panoramURL);
              //     // setState(() {
                    
              //     // });
              //   },
              //   //child: Image.asset('assets/p.jpg'),
              //   child: panoram,      
              // ),
            
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              height: 50,
              margin: const EdgeInsets.only(left: 130, right: 130,bottom: 20),
              decoration: BoxDecoration(
                color: cTheme.withAlpha(120),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(30)     
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.arrow_back_outlined),
                  //   tooltip: 'Вернуться на главную',
                  //   onPressed: () {
                  //     //updateColor();
                  //   },
                  // ),
                  IconButton(
                    color: Colors.black,
                    icon: const Icon(Icons.remove_red_eye_sharp),
                    tooltip: 'Больше информации',
                    onPressed: () {
                      //updateColor();
                    },
                  ),
                  IconButton(
                    tooltip: 'Cохранить в закладки',
                    color: Colors.black,
                    onPressed: (){

                    },
                    icon: const Icon(Icons.turned_in_outlined),
                  ),
                  
                ],
              ),

            ),
            
          ),
        ],
      ),
    );
  }
}