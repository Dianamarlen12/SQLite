import 'crud_operations.dart';
import 'student.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class select extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<select> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<List<Student>> Studentss;
  /*TextEditingController controllermatricula = TextEditingController();
  TextEditingController controllername = TextEditingController();
  TextEditingController controllerapepate = TextEditingController();
  TextEditingController controllerapemate = TextEditingController();
  TextEditingController controllercorreo = TextEditingController();
  TextEditingController controllertelefono = TextEditingController();*/
  TextEditingController controller = TextEditingController();
  String matricula;
  String name;
  String apepate;
  String apemate;
  String correo;
  String telefono;
  int currentUserId;
  int count;
  String val;

  //final formkey = new GlobalKey<FormState>();
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
      Studentss = bdHelper.getStudents(val);
    });
  }

  void cleanData() {
    controller.text = "";
  }

  void dataValidatee() async{
    print(val.toUpperCase());
    Student stu = Student(null, matricula, name, apepate, apemate, correo, telefono);
    var col = await bdHelper.search(val.toUpperCase());
    //print(col);
    if (col.length < 1){
      showInSnackBar("Data not found");
      val=null;
      cleanData();
      refreshList();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(backgroundColor: Colors.red,));
  }

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
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Buscar"),
              validator: (val) => val.length == 0 ? 'Buscar' : null,
              onSaved: (val) => matricula = val.toString().toUpperCase(),
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
                  onPressed: () {
                    showInSnackBar(("Data not found"));
                    val=null;
                    cleanData();
                    refreshList();
                  },
                  //SI ESTA LLENO ACTUALIZAR, SI NO AGREGAR
                  child: Text(isUpdating ? 'Update' : 'Search'),
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
                    val=null;
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


//SHOW DATA
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text("Numero de control"),
            ),
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
              label: Text("Telefono"),
            ),
            DataColumn(
              label: Text("Correo"),
            ),
          ],
          rows: Studentss.map((student) =>
              DataRow(cells: [
                DataCell(Text(student.controlnum.toString())),
                DataCell(Text(student.matricula.toString())),
                DataCell(Text(student.name.toString())),
                DataCell(Text(student.apepate.toString())),
                DataCell(Text(student.apemate.toString())),
                DataCell(Text(student.telefono.toString())),
                DataCell(Text(student.correo.toString())),
              ])).toList(),
        ),
      ),
    );
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

  final formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[100],
      resizeToAvoidBottomInset: false,   //new line
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: Text('SELECT DATA'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //form(),
            list(),
          ],
        ),
      ),
    );
  }
}