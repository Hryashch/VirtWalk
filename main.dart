import 'package:flutter/material.dart';



import 'placesearch.dart';    
import 'placeitem.dart';
import 'testgoogleview.dart';


import 'dart:math';


const places = ['набережная с пальмами',
  'узкая европейская улица',
  'средневековый замок',
  'горный перевал',
  'Эмпайр стейт',
  'Красная площадь'
];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
Color getRandomColor(){
  Random random = new Random();
  return Color.fromRGBO(random.nextInt(155)+100, random.nextInt(155)+100, random.nextInt(155)+100, 1.0);
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showGrid = false;
  Color cTheme = Color.fromARGB(255, 83, 152, 255);
  String srch = "";
  List<dynamic> ps=[];
  void updateColor() {
    setState(() {
      cTheme = getRandomColor(); 
    });
  }
  void _onSearchSubmitted() async {
    setState(() {
      showGrid = false;
    });
    if (srch.isNotEmpty) {
      ps = await searchPlaces(srch);
      setState(() {
        showGrid = true; 
      });
    }
    else {
      setState(() {
        showGrid = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            child: Text('VirtWalker'),
            margin: EdgeInsets.only(left: 40),
            )
          ),
        backgroundColor: cTheme.withAlpha(240),
        actions: [
          IconButton(
                  tooltip: 'Открыть настройки',
                  icon: Icon(Icons.settings_outlined),
                  onPressed: () {
                    updateColor();
                  },
                ),
        ],
      ),
      
      body:
      	Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                if(!showGrid)Column(
                  children: [
                    Text(
                      'Куда пойдем гулять сегодня? \n Введите описание места:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: cTheme,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                  ],
                ),
                Container(
                  constraints: BoxConstraints( maxWidth: 500),
                  child: TextField( 
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: cTheme,
                           width: 5
                          )
                        ),
                      hintText: srch==''?'Например, ${places[Random().nextInt(places.length)]}' : srch,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      srch = value;
                    },
                    onSubmitted: (value) {
                      _onSearchSubmitted();
                      
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(cTheme),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: Color(0xFF000000),
                          width: 1.5,
                        ),
                      )),
                    ),
                    onPressed: () {
                      _onSearchSubmitted();
                    },
                    child: RichText(
                      text:const TextSpan(
                        text: 'искать',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)
                      ),
                      ),
                  ),
                ),
                if(showGrid)
                  Expanded(
                    child:  PlacesGrid.fromPlace(ps: ps) ,
                  )
              ],
            ),
          ),
        ),
    );
  }
}