
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../datos/database_helper.dart';
import '../../generated/l10n.dart';

class AddCamara extends StatefulWidget {
  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddCamara> {


  TextEditingController controllerNombreAula = TextEditingController();
  TextEditingController controllerDirCam = TextEditingController();
  var db;
  final _formKey = GlobalKey<FormState>();
  late FToast fToast;
  String estadoRegristro = "";

  @override
  void initState() {
    db = DatabaseHelper(); //inicializa la bd para su uso posterior
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  /*
  Este metodo muestra un toast personalizado para mostrar las alertas necesarias
  se requiere un String para poder mostrar el mensaje necesario.
   */
  _showToast(String message, Color color) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.white70,),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              message,style: const TextStyle(color: Colors.white70),
            ),
          )
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  registro(String nombreAula, String dirCam){
    db.registroCamaras(nombreAula, dirCam).catchError((Object error) => estadoRegristro = error.toString());

    if(estadoRegristro.isNotEmpty){
      _showToast(estadoRegristro, Colors.redAccent);
    }else{
      _showToast(S.of(context).camOk, Colors.greenAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Center(
          child: Text(S.of(context).addCam),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Padding(padding: EdgeInsets.only(top: 50),),
                  ListTile(
                    leading: const Icon(Icons.drive_file_rename_outline_rounded, color: Colors.white70),
                    title: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: controllerNombreAula,
                      validator: (value) {
                        if (value != null) {
                          return S.of(context).addName;
                        }
                      },
                      decoration: InputDecoration(
                        iconColor: Colors.white,
                        hintStyle: const TextStyle(color: Colors.white),
                        hintText: S.of(context).name,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.video_camera_front_rounded, color: Colors.white),
                    title: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: controllerDirCam,
                      validator: (value) {
                        if (value != null) {
                          return S.of(context).addIP;
                        }
                      },
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        hintText: S.of(context).IP,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(30.0),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))
                    ),
                    onPressed: () {
                      if(controllerNombreAula.text.isEmpty &&controllerDirCam.text.isEmpty){
                        _showToast(S.of(context).addEmpty, Colors.red);
                      }else {
                        registro(
                            controllerNombreAula.text,
                            controllerDirCam.text);
                        Navigator.pop(context, true);
                      }
                    },
                    child:  Text(S.of(context).addButton, style: const TextStyle(color: Colors.white),)
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
