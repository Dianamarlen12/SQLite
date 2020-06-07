import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'main.dart';

class insert extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<insert> {
  //VARIABLES REFERENTES AL MANEJO DE LA BD


  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Student>> Studentss;

  //CONTROLLERS
  TextEditingController controllermatricula = TextEditingController();
  TextEditingController controllername = TextEditingController();
  TextEditingController controllerapepate = TextEditingController();
  TextEditingController controllerapemate = TextEditingController();
  TextEditingController controllercorreo = TextEditingController();
  TextEditingController controllertelefono = TextEditingController();
  String matricula = null;
  String name;
  String apepate;
  String apemate;
  String correo;
  String telefono;
  int currentUserId;
  int count;

  var bdHelper;
  bool isUpdating; //PARA SABER ESTADO ACTUAL DE LA CONSULTA

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents(matricula);
    });
  }


  void cleanData() {
    controllermatricula.text = "";
    controllername.text = "";
    controllerapepate.text = "";
    controllerapemate.text = "";
    controllertelefono.text = "";
    controllercorreo.text = "";
  }




  void verificar() async {
    print("bandera1");
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      print("bandera2");
      if (isUpdating) {
        Student stu = Student(
            currentUserId, name, matricula,apepate,apemate,correo,telefono);
        bdHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        print("bandera3");
        print(name);
        print(matricula);
        Student stu =
        Student(null, matricula,name,apepate,apemate,correo,telefono);
        var col = await bdHelper.getMatricula(matricula);
        print(col);
        if (col == 0) {
          print("bandera4");
          bdHelper.insert(stu);
          print("listo");
          showInSnackBar(context,"Data saved");
        } else {
          print("erorr");
          showInSnackBar(context,"Error! Ya existe esta matricula");
        }
      }
      print("bandera5");
      cleanData();
      refreshList();
    }
  }

  final formkey = new GlobalKey<FormState>();

  //FORMULARIO
  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 10.0),
            //TEXT FIELD PARA DATOS DEL FORMULARIO
            TextFormField(
              controller: controllermatricula,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Matricula"),
              validator: (val) => val.length == 0 ? 'Ingresa nombre' : null,
              onSaved: (val) => matricula = val.toUpperCase(),
            ),
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllername,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Nombre"),
              validator: (val) => val.length == 0 ? 'Inténtelo de nuevo' : null,
              onSaved: (val) => name = val.toUpperCase(),
            ),
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllerapepate,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Apellido Paterno"),
              validator: (val) => val.length == 0 ? 'Inténtelo de nuevo' : null,
              onSaved: (val) =>apepate = val.toUpperCase(),
            ),
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllerapemate,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Apellido Materno"),
              validator: (val) => val.length == 0 ? 'Inténtelo de nuevo' : null,
              onSaved: (val) => apemate = val.toUpperCase(),
            ),
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllercorreo,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "E-mail"),
              validator: (val) => !val.contains('@') ? 'Correo incorrecto' : null,
              onSaved: (val) => correo = val,
            ),
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllertelefono,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Telefono"),
              validator: (val) => val.contains('numeros') ? 'Ingrese numeros' : null,
              onSaved: (val) => telefono = val.toUpperCase(),
            ),
            SizedBox(height: 30),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: () async {
                    verificar();
                  },
                  //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                  child: Text(isUpdating ? 'Update' : 'Add Data'),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    cleanData();
                  },
                  child: Text("Cancel"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[100],
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text('INSERT DATA'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            //list(),
          ],
        ),
      ),
    );
  }


  showInSnackBar(BuildContext context, String texto) {
    final snackBar = SnackBar(
        backgroundColor: Colors.blue,
        content: new Text(texto,
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Schyler',
              fontWeight: FontWeight.bold,
            )));
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

}