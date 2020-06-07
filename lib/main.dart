import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'insert.dart';
import 'delte.dart';
import 'update.dart';
import 'select.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  //Variables referentes al manejo de la BD


  final _scafoldkey = GlobalKey<ScaffoldState>();
  var bdHelper;

  //Estado actual de la consulta
  bool isUpdating;

  /*final textFormField = TextFormField(
    textCapitalization: TextCapitalization.characters,
  );*/

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[100],
      key: _scafoldkey,
      //MENU LATERAL
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text("INTEGRANTES",
                  style: TextStyle(
                      fontFamily: 'Carter', fontSize: 30, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text('MENESES ALEGRIA DIANA MARLEN',
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),),
            ),
            ListTile(
              title: Text("INSERTAR",
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new insert()
                    ));
              },),
            ListTile(
              title: Text(
                "ACTUALIZAR",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new update()
                    ));
              },),
            ListTile(
              title: Text(
                "BORRAR Y BUSCAR",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new delete()
                    ));
              },),
            ListTile(
              title: Text(
                "SELECCIONAR",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new select()
                    ));
              },),
          ],
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'OPERACIONES SQL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,),),),
      body: ListView(
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
              child: Center(
                child: Container(
                  width: 350,
                  height: 350,
                  child: Image.network(
                      'https://2.bp.blogspot.com/-93Mt1QRv6Bo/V8G22oUacrI/AAAAAAAAC5k/Id7DOEm558QOBR4kizycJ1iH1yaDp_gCgCLcB/s1600/sqlite.png'),
            ),
          ),
        ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text("BASE DE DATOS", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],),
        );
  }
}


