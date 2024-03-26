import 'dart:math';
import 'package:flutter/material.dart';
import 'panoram.dart';
import 'placeitem.dart';

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
  Color cTheme = Color.fromARGB(255, 83, 152, 255);
  String srch = "";

  void updateColor() {
    setState(() {
      cTheme = getRandomColor(); 
    });
  }
  void display(){
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Color.fromARGB(255, 255, 246, 240),
      context: context,
      builder: (BuildContext context){
        return SingleChildScrollView( 
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, 
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9, 
            ),
            child: PlacesGrid(name: srch),
          ),
        );
      }
    );
    
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PlacesGrid(name:srch);
      },
    );
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
              children: <Widget>[
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
                      hintText: 'Например, ${places[Random().nextInt(places.length)]}',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      srch = value;
                    },
                    onSubmitted: (value) {
                      displayBottomSheet(context);

                      // setState(() {
                      //   display();
                      // });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Color(0xFF000000), width: 1,), 
                  //   borderRadius: const BorderRadius.all(Radius.circular(30)),),
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
                    onPressed: (){
                      updateColor();
                      print(srch);
                      //display();
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => PanoramViewScreen())
                      );
                    },
                    child: RichText(
                      text:const TextSpan(
                        text: 'искать',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2)
                      ),
                      ),
                  ),
                ),
                //PlaceItem(';jgf')
              ],
            ),
          ),
        ),
    );
  }
}
