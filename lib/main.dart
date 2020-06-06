import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/delete.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'dart:async';
import 'insert.dart';
import 'delete.dart';
import 'update.dart';
import 'select.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  //Variables referentes al manejo de la bd
  Future<List<Student>> Studentss;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  String name;
  String surname;
  String ap;
  String mat;
  String mail;
  String num;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents();
    });
  }

  void cleanData() {
    controller1.text = "";
    controller2.text = "";
    controller3.text = "";
    controller4.text = "";
    controller5.text = "";
    controller6.text = "";
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Control"),
          ),
          DataColumn(
            label: Text("Name"),
          ),
          DataColumn(
            label: Text("Paternal Surname"),
          ),
          DataColumn(
            label: Text("Maternal Surname"),
          ),
          DataColumn(
            label: Text("Studen ID"),
          ),
          DataColumn(
            label: Text("Mail"),
          ),
          DataColumn(
            label: Text("Numero"),
          ),
         /* DataColumn(label: Text("Delete")),
          DataColumn(label: Text("Update"))*/
        ],
        rows: Studentss.map((student) => DataRow(cells: [
              DataCell(Text(student.controlum.toString())),
              DataCell(Text(student.name.toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  currentUserId = student.controlum;
                });
                controller1.text = student.name;
              }),
              //CONVIERTE LETRAS
              DataCell(Text(student.surname.toUpperCase())),
              DataCell(Text(student.ap.toUpperCase())),
              DataCell(Text(student.mat.toUpperCase())),
              DataCell(Text(student.mail.toUpperCase())),
              DataCell(Text(student.num.toUpperCase())),
            /*  DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  bdHelper.delete(student.controlum);
                  refreshList();
                  _snack(context, "El elemento ha sido eliminado");
                },
              )),
              DataCell(IconButton(
                icon: Icon(Icons.update),
                onPressed: () {
                 ( bdHelper.update(student.controlum);)
                  refreshList();
                },
              ))*/
            ])).toList(),
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
    // TODO: implement build
    return new Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  "MENU",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: Icon(Icons.system_update_alt),
              title: Text('ACTUALIZAR TABLA'),
              onTap: refreshList,
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('INSERTAR DATOS'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => insert()));
              },
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('ACTUALIZAR DATOS'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Update()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('BUSCAR DATOS'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Select()));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('ELIMINAR DATOS'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => eliminar()));
              },
            ),
          ],
        ),
      ),
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text("Basic SQL operations"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
        body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }

  _snack(BuildContext context, String texto) {
    final snackbar = SnackBar(
      content: new Text(texto),
      backgroundColor: Colors.deepPurple,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }
}
