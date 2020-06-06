import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'students.dart';
import 'crud_operations.dart';

class insert extends StatefulWidget {
  @override
  _Insertar createState() => new _Insertar();
}

class _Insertar extends State<insert> {
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
  final formkey = new GlobalKey<FormState>();

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

  /* void guardar(){
    setState(() {
      _snack(context,"Datos guardados!");
    });
  }*/

  void cleanData() {
    controller1.text = "";
    controller2.text = "";
    controller3.text = "";
    controller4.text = "";
    controller5.text = "";
    controller6.text = "";
  }

  void dataValidate() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu = Student(currentUserId, name, surname, ap, mat, mail, num);
        bdHelper.update(stu);
        setState(() {
          isUpdating = false;
        });
      } else {
        Student stu = Student(null, name, surname, ap, mat, mail, num);
        //VALIDACION MATRICULA
        var validation = await bdHelper.validateInsert(stu);
        print(validation);
        if (validation) {
          bdHelper.insert(stu);
          final snackbar = SnackBar(
            content: new Text("DATOS INGRESADOS!"),
            backgroundColor: Colors.deepPurple,
          );
          _scaffoldkey.currentState.showSnackBar(snackbar);
        } else {
          final snackbar = SnackBar(
            content: new Text("LA MATRICULA YA FUE REGISTRADA!"),
            backgroundColor: Colors.deepPurple,
          );
          _scaffoldkey.currentState.showSnackBar(snackbar);
        }
      }
      cleanData();
      refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text("Insertar Datos "),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  controller: controller1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Student Name"),
                  validator: (val) => val.length == 0 ? 'Enter name' : null,
                  onSaved: (val) => name = val,
                ),
                TextFormField(
                  controller: controller2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Paternal Surname"),
                  validator: (val) =>
                      val.length == 0 ? 'Enter paternal surname' : null,
                  onSaved: (val) => surname = val,
                ),
                TextFormField(
                  controller: controller5,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Maternal Surname"),
                  validator: (val) =>
                      val.length == 0 ? 'Enter maternal surname' : null,
                  onSaved: (val) => ap = val,
                ),
                TextFormField(
                  controller: controller6,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Student ID"),
                  validator: (val) =>
                      val.length < 10 ? 'Enter student id' : null,
                  onSaved: (val) => mat = val,
                ),
                TextFormField(
                  controller: controller3,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Student Mail"),
                  validator: (val) => !val.contains('@') ? 'Enter mail' : null,
                  onSaved: (val) => mail = val,
                ),
                TextFormField(
                  controller: controller4,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Student phone"),
                  validator: (val) =>
                      val.length < 10 ? 'Enter phone number' : null,
                  onSaved: (val) => num = val,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.deepPurple)),
                      onPressed: dataValidate,
                      child: Text(isUpdating ? 'Update' : 'Add Data'),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.deepPurple)),
                      onPressed: () {
                        setState(() {
                          isUpdating = false;
                        });
                        cleanData();
                      },
                      child: Text('Cancel'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
