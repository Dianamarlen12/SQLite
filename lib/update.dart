import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'main.dart';

class update extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<update> {
  //Variable referentes al manejo de la BD

  Future<List<Student>> Studentss;
  TextEditingController controllermatricula = TextEditingController();
  TextEditingController controllername = TextEditingController();
  TextEditingController controllerapepate = TextEditingController();
  TextEditingController controllerapemate = TextEditingController();
  TextEditingController controllercorreo = TextEditingController();
  TextEditingController controllertelefono = TextEditingController();
  String matricula;
  String name;
  String apepate;
  String apemate;
  String correo;
  String telefono;
  int currentUserId;
  int opcion;
  String campo;
  //

  String descriptive_text = "Student Name";

  final formkey = new GlobalKey<FormState>();
  var bdHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  //select
  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents(null);
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

  /* void dataValidate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name);
        dbHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }*/


  //Student e = Student(curUserId, name);

  void updateData() async{
    print("Valor de Opción");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (opcion==1) {
        campo="matricula";
        var col = await bdHelper.getMatricula(controllermatricula.text);
        print(col);
        if (col == 0) {
          print("bandera4");
          Studentupdate stu = Studentupdate(currentUserId,campo,controllermatricula.text);
          bdHelper.studentssupdate(stu);
          print("listo");
          showInSnackBar(context,"Data saved");
        } else {
          print("erorr");
          showInSnackBar(context,"Error! Ya existe esta matricula");
        }

      }
      else if (opcion==2) {
        print(controllername.text);
        campo="name";
        Studentupdate stu = Studentupdate(currentUserId,campo,controllername.text.toUpperCase());
        bdHelper.studentssupdate(stu);
        print("listo00");
      }
      else if (opcion==3) {
        campo="apepate";
        Studentupdate stu = Studentupdate(currentUserId,campo,controllerapepate.text.toUpperCase());
        bdHelper.studentssupdate(stu);
      }
      else if (opcion==4) {
        campo="apemate";
        Studentupdate stu = Studentupdate(currentUserId,campo,controllerapemate.text.toUpperCase());
        bdHelper.studentssupdate(stu);
      }
      else if (opcion==5) {
        campo="correo";
        Studentupdate stu = Studentupdate(currentUserId,campo,controllercorreo.text);
        bdHelper.studentssupdate(stu);
      }
      else if (opcion==6) {
        campo="telefono";
        Studentupdate stu = Studentupdate(currentUserId,campo,controllertelefono.text);
        bdHelper.studentssupdate(stu);
      }

      cleanData();
      refreshList();
    }
  }

  void insertData() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      {
        Student stu = Student(null, matricula, name, apepate, apemate, telefono, correo);
        bdHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }
  //Formulario

  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 50.0),
            TextFormField(
              controller: opcion==1?controllermatricula:
              opcion==2?controllername:
              opcion==3?controllerapepate:
              opcion==4?controllerapemate:
              opcion==5?controllercorreo:
              controllertelefono,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text),
              validator: (val) => val.length == 0 ? 'Enter Data' : null,
              onSaved: (val) => val = val,
            ),

            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: updateData,
                  //child: Text(isUpdating ? 'Update ' : 'Add Data'),
                  child: Text('Update Data'),
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
                    refreshList();
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

  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text("Matricula"),
            ),
            DataColumn(
              label: Text("Nombre"),
            ),
            DataColumn(
              label: Text("Apellido Paterno"),
            ),
            DataColumn(
              label: Text("Apellido Materno"),
            ),
            DataColumn(
              label: Text("Correo"),
            ),
            DataColumn(
              label: Text("Telefono"),
            ),
            DataColumn(
              label: Text("Eliminar"),
            ),
          ],
          rows: Studentss.map((student) => DataRow(cells: [
            DataCell(Text(student.matricula), onTap: () {
              setState(() {
                //isUpdating = true;
                descriptive_text = "Student Name";
                controllername.text = student.name;
                controllerapepate.text = student.apepate;
                controllerapemate.text = student.apemate;
                controllercorreo.text = student.correo;
                controllertelefono.text = student.telefono;
                controllermatricula.text = student.matricula;
                opcion=1;
                currentUserId = student.controlnum;
              });
              controllermatricula.text = student.matricula;
            }
            ),
            DataCell(Text(student.name), onTap: () {
              setState(() {
                //isUpdating = true;
                descriptive_text = "Student Name";
                controllername.text = student.name;
                controllerapepate.text = student.apepate;
                controllerapemate.text = student.apemate;
                controllercorreo.text = student.correo;
                controllertelefono.text = student.telefono;
                controllermatricula.text = student.matricula;
                currentUserId = student.controlnum;
                opcion=2;
              });
              controllername.text = student.name;
            }),
            DataCell(Text(student.apepate),onTap: (){
              setState(() {
                //isUpdating = true;
                descriptive_text = "Student Name";
                controllername.text = student.name;
                controllerapepate.text = student.apepate;
                controllerapemate.text = student.apemate;
                controllercorreo.text = student.correo;
                controllertelefono.text = student.telefono;
                controllermatricula.text = student.matricula;
                currentUserId = student.controlnum;
                opcion=3;
              });
              controllerapepate.text = student.apepate;
            },),
            DataCell(Text(student.apemate),onTap: (){
              setState(() {
                //isUpdating = true;
                descriptive_text = "Student Name";
                controllername.text = student.name;
                controllerapepate.text = student.apepate;
                controllerapemate.text = student.apemate;
                controllercorreo.text = student.correo;
                controllertelefono.text = student.telefono;
                controllermatricula.text = student.matricula;
                currentUserId = student.controlnum;
                opcion=4;
              });
              controllerapemate.text = student.apemate;
            },),
            DataCell(Text(student.correo),onTap: (){
              setState(() {
                //isUpdating = true;
                controllername.text = student.name;
                controllerapepate.text = student.apepate;
                controllerapemate.text = student.apemate;
                controllercorreo.text = student.correo;
                controllertelefono.text = student.telefono;
                controllermatricula.text = student.matricula;
                currentUserId = student.controlnum;
                opcion=5;
              });
              controllercorreo.text = student.correo;
            },),
            DataCell(Text(student.telefono), onTap: (){
              setState(() {
                //isUpdating = true;
                descriptive_text = "Student Name";
                controllername.text = student.name;
                controllerapepate.text = student.apepate;
                controllerapemate.text = student.apemate;
                controllercorreo.text = student.correo;
                controllertelefono.text = student.telefono;
                controllermatricula.text = student.matricula;
                currentUserId = student.controlnum;
                opcion=6;
              });
              controllertelefono.text = student.telefono;
            },),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                bdHelper.delete(student.controlnum);
                refreshList();
                //_alert (context, "El elemento fue eliminado");
              },
            )),
          ])).toList(),
        ),
      ),);
  }


  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data founded!");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.blue[100],
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,   //new line
      appBar: new AppBar(
        title: Text('Flutter Basic SQL Operations'),
        backgroundColor: Colors.blue,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
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