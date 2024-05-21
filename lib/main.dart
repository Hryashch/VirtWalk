import 'package:flutter/material.dart';

import 'globals.dart';
import 'placesearch.dart';    
import 'placeitem.dart';

import 'savedplacespage.dart';

import 'dart:math';


const places = ['набережная с пальмами',
  'кафе с верандой',
  'пустыня в африке',
  'горнолыжный курорт',
  'торговый центр',
  'японский парк'
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  saveService.loadStuff();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 248, 112, 184),
          brightness: Brightness.light,
          primary: const Color.fromARGB(255, 241, 90, 79),
          secondary: const Color.fromARGB(255, 250, 195, 224),
          // seedColor: Color(0xFF8F40)
           
        )
      ),
      debugShowCheckedModeBanner: false, 
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showGrid = false;
  String srch = "";
  List<dynamic> ps=[];
  TextEditingController _controller = TextEditingController();
  
  void _onSearchSubmitted() async {
    setState(() {
      showGrid = false;
    });
    if (srch.isNotEmpty) {
      ps = await searchPlaces(srch);
      setState(() {
        showGrid = true; 
      });
      if(ps.isNotEmpty) {
        saveService.addPrevSrch(srch);
      }
    }
    else {
      setState(() {
        showGrid = false; 
      });
    }
  }
  bool showText = true;

  @override
  Widget build(BuildContext context) {
    Widget wheelPrevs = 
      Stack(
        children: [
          ListWheelScrollView(
          onSelectedItemChanged: (value) {
            showText = value < 1;
            setState(() {
              
            });
          },
          itemExtent: 50,
          squeeze: 0.7,
          // useMagnifier: true,
          // magnification: 1.1,
          diameterRatio: 1.5,
          children: [
            for (int i = prevSrchs.length-1; i >=0; i--)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary.withOpacity(0.7)),
                  elevation: WidgetStateProperty.all(0),
                  shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                    side: BorderSide(
                      color: Color(0xFF000000),
                      width: 1,
                    )
                  ))
                ),
                onPressed: () {
                  srch=prevSrchs[i];
                  _onSearchSubmitted();
                },
                child: RichText(
                  text: TextSpan(
                    text: prevSrchs[i],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)
                  ),
                ),
              ),
            ],
          ),
          if(prevSrchs.isNotEmpty) 
          AnimatedOpacity(
            opacity: showText ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      saveService.clearPrevSrchs();
                      setState(() {
                        
                      });
                    },
                      child: const Text('очистить историю')
                  ),
                  const FancyTextWidget(text: 'До этого Вы искали:'),
                ],
              )
            
            ),
          )
        ],
      );


    Widget btnSrch = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          side: BorderSide(
            color: Color(0xFF000000),
            width: 1.5,
          ),
        )),
        // minimumSize: WidgetStateProperty.all(Size(100, 40))
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
    );
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradColors.sublist(2),
            )
          ),
        ),
        title: const FancyTextWidget(text: 'Поиск мест') ,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Открыть закладки',
            icon: const Icon(Icons.turned_in_not_outlined),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarksPage(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Открыть настройки',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
            },
          ),
        ],
      ),
      
      body:
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradColors.map((color) => color.withOpacity(0.5)).toList(),
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            
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
                    const FancyTextWidget(text: 'Куда пойдем гулять сегодня?\nВведите описание места'),
                  if(!showGrid)  
                  const SizedBox(height: 40),
                  Container(
                    constraints: const BoxConstraints( maxWidth: 500),
                    child: TextField( 
                      controller: _controller,
                      decoration: InputDecoration(
                        suffixIcon: 
                        // srch!=''?
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 700),
                            opacity: srch!=''?1:0,
                            child: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  srch = "";
                                  showGrid = false;
                                  _controller.clear();
                                });
                              },
                            ),
                          ),
                          // : null,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
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
                  
                  Container(
                    alignment: Alignment.topCenter,
                    
                    width: MediaQuery.sizeOf(context).width*0.7,
                    height: MediaQuery.sizeOf(context).height*0.4,
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                      maxHeight: 500
                    ),
                    child:  AnimatedCrossFade(
                      alignment: Alignment.topCenter,
                      firstChild: btnSrch,
                      secondChild: ShaderMask(shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
                          stops: [0.0,0.1,0.7,0.9]
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child:Container(
                        width: MediaQuery.sizeOf(context).width*0.7,
                        height: MediaQuery.sizeOf(context).height*0.4,
                        child: wheelPrevs,
                      )),
                      // secondChild: Text('sadasd'),
                      crossFadeState: srch!=''?
                        CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 1000),
                      reverseDuration: const Duration(milliseconds:1500),
                    ),
                  )
                  else
                    if(ps.isNotEmpty)
                      Expanded(
                        child:  PlacesGrid.fromPlace(ps: ps) ,
                      )
                    else 
                      Column(
                        children: [
                          RichText(
                            text:const TextSpan(
                              text: 'нет результатов поиска',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 18, 
                                letterSpacing: 1,
                                color: Colors.black,   
                              )
                            ),
                          ),
                          const Icon(
                            Icons.sentiment_dissatisfied_outlined,
                            size: 50,
                            )
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}