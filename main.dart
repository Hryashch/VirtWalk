import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
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
      final random = Random();
      cTheme = Color.fromARGB(255,
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VirtWalker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Например, набережная с пальмами',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  srch = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(cTheme),
                ),
                onPressed: (){

                  updateColor();
                  print(srch);
                           
                
                },
                child: Text('Искать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
