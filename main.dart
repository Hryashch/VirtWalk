import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'placesearch.dart';    
import 'placeitem.dart';
// import 'testgoogleview.dart';


import 'dart:math';
/*
          идеи

  1 для плейсайтемов брать не размер экрана а размер плейсайтема(этовозможно?!??!?!)
  3 поиск соседних мест по заготовленным запросам

  15 закладки
  ...

*/

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
      theme: ThemeData(
        primaryColor: getRandomColor(),
        
      ),
      debugShowCheckedModeBanner: false, 
      // theme: ThemeData(),
      // darkTheme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
Color getRandomColor(){
  Random random = new Random();
  return Color.fromRGBO(
    random.nextInt(155)+100,
    random.nextInt(155)+100,
    random.nextInt(155)+100,
    1.0);
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showGrid = false;
  Color cTheme = const Color.fromARGB(255, 83, 152, 255);
  String srch = "";
  List<dynamic> ps=[];
  TextEditingController _controller = TextEditingController();
  void updateColor() {
    setState(() {
      cTheme = getRandomColor(); 
      // Theme.of(context).colorScheme.primary = cTheme;
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              // Theme.of(context).colorScheme.primary,
              cTheme
            ])
          ),
        ),
        title: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 40),
            child: const Text('VirtWalker'),
            )
          ),
        // backgroundColor: cTheme.withAlpha(240),
        actions: [
          IconButton(
            tooltip: 'Открыть настройки',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              updateColor();
            },
          ),
        ],
      ),
      
      body:
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              // Theme.of(context).colorScheme.secondary.withOpacity(0.4),
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              cTheme.withOpacity(0.3)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            )
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!showGrid)
                    Text(
                      'Куда пойдем гулять сегодня? \n Введите описание места:',
                      style: TextStyle(
                        fontSize: 25.0,
                        shadows: const [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black,
                            offset: Offset(1, 1)
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                        color: cTheme,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 40),
                  Container(
                    constraints: const BoxConstraints( maxWidth: 500),
                    child: TextField( 
                      controller: _controller,
                      decoration: InputDecoration(
                        suffixIcon: 
                        srch!=''?
                          IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              srch = "";
                              showGrid = false;
                              _controller.clear();
                            });
                          },
                        )
                      : null,
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
                        setState(() {
                          
                        });
                      },
                      onSubmitted: (value) {
                        _onSearchSubmitted();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if(!showGrid) 
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: srch!='' ? 1 : 0,
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
                  )
                  else
                    Expanded(
                      child:  PlacesGrid.fromPlace(ps: ps) ,
                    )
                ],
              ),
            ),
          ),
        ),
    );
  }
}