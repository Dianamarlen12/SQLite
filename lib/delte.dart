import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';

class delete extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<delete> {
  //final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Student>> Studentss;
  TextEditingController controllermatricula = TextEditingController();
  /*TextEditingController controllername = TextEditingController();
  TextEditingController controllerapepate = TextEditingController();
  TextEditingController controllerapemate = TextEditingController();
  TextEditingController controllercorreo = TextEditingController();
  TextEditingController controllertelefono = TextEditingController();*/
  String matricula=null;
  String name;
  String apepate;
  String apemate;
  String correo;
  String telefono;
  int currentUserId;
  int count;

  var bdHelper;
  bool isUpdating;
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
    /*controllername.text = "";
    controllerapepate.text = "";
    controllerapemate.text = "";
    controllertelefono.text = "";
    controllercorreo.text = "";*/
  }
  void verificar() async{
    Student stu =
    Student(null, matricula, name, apepate, apemate, correo, telefono);
    var col = await bdHelper.getMatricula(matricula);
    print(col);
    if (col == 0) {
      showInSnackBar("Data not found!");
      matricula=null;
      cleanData();
      refreshList();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: Colors.blue));
  }

  //MOSTRAR DATOS
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
                label: Text("Name"),
              ),
              DataColumn(
                label: Text("Apellido paterno"),
              ),
              DataColumn(
                label: Text("Apellido Materno"),
              ),
              DataColumn(
                label: Text("Telefono"),
              ),
              DataColumn(
                label: Text("Correo"),
              ),
              DataColumn(
                label: Text("Delete"),
              ),
            ],
            rows: Studentss.map((student) => DataRow(cells: [
              //DataCell(Text(student.controlnum.toString())),
              DataCell(Text(student.matricula.toString().toUpperCase())),
              DataCell(Text(student.name.toString().toUpperCase())),
              DataCell(Text(student.apepate.toString().toUpperCase())),
              DataCell(Text(student.apemate.toString().toUpperCase())),
              DataCell(Text(student.telefono.toString().toUpperCase())),
              DataCell(Text(student.correo.toString().toUpperCase())),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  bdHelper.delete(student.controlnum);
                  refreshList();
                },
              )),
            ])).toList(),
          ),
        ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[100],
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          "DELETE DATA SQFLite",
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.only(top:35.0, right: 15.0,bottom: 35.0,left: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextFormField(
                      controller: controllermatricula,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Matricula',),
                      validator: (val) =>
                      (val.length <10 && val.length > 1) ? 'Matricula' : null,
                      onSaved: (val) => matricula = val,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue, width: 2.0)),
                          onPressed: () {
                            matricula=controllermatricula.text;
                            if(matricula==""){
                              showInSnackBar("Data not found!");
                              matricula=null;
                              cleanData();
                              refreshList();
                            }else{
                              verificar();
                              refreshList();
                            }
                          },
                          child: Text(isUpdating ? 'Update' : 'Search Data', style: TextStyle(fontSize: 17.0),),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue, width: 2.0)),
                          onPressed: () {
                            setState(() {
                              isUpdating = false;
                            });
                            cleanData();
                            matricula=null;
                            refreshList();
                          },
                          child: Text('CANCEL', style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    ),
                    Row(children: <Widget>[ list()])
                  ],
                ),
              ),
            ),
          )),
    );}
}