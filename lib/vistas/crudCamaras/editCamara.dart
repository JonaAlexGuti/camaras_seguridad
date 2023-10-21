import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../datos/database_helper.dart';
import '../../generated/l10n.dart';
import '../../modelos/camaras.dart';

class EditCamara extends StatefulWidget {
  late List<Camara> listCam = List.empty(growable: true);
  int index;

  EditCamara({required this.index, required this.listCam});

  @override
  _EditCamaraState createState() => _EditCamaraState(index, listCam);
}

class _EditCamaraState extends State<EditCamara> {

  late String nombreAula,dirCam,claveApi;
  late TextEditingController controllernombreAula;
  late TextEditingController controllerdirCam;
  late List<Camara> listCam = List.empty(growable: true);
  late int index;
  late FToast fToast;
  var db;
  String estadoEliminar = "";
  _EditCamaraState(this.index, this.listCam);

  @override
  void initState() {
    db = DatabaseHelper(); //inicializa la bd para su uso posterior
    fToast = FToast();
    fToast.init(context);

    controllernombreAula= TextEditingController(text: listCam[index].nombreCamara );
    controllerdirCam= TextEditingController(text: listCam[index].dirCam);
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
          const Icon(Icons.error, color: Colors.white,),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              message,style: const TextStyle(color: Colors.white),
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

  Future<void> editData(String nombreCamara, String dirCam) async {
    db.actualizarCamaras(listCam[index].idCamara, nombreCamara, dirCam).catchError((Object error) => estadoEliminar = error.toString());
    if(estadoEliminar.isNotEmpty){
      _showToast(estadoEliminar, Colors.redAccent);
    }else{
      _showToast(S.of(context).camUpd, Colors.greenAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Center(child: Text(S.of(context).editCamInfo)),
        backgroundColor: Colors.black87,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.drive_file_rename_outline_rounded, color: Colors.white),
                  title: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: controllernombreAula,
                    validator: (value) {
                      if (value != null) {
                        return S.of(context).addName;
                      }
                      return "";
                    },
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Colors.white
                      ),
                      hintText: S.of(context).name,
                      labelText: S.of(context).name,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.video_camera_front_rounded, color: Colors.white),
                  title: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    controller: controllerdirCam,
                    validator: (value) {
                      if (value != null) {
                        return S.of(context).addIP;
                      }
                      return "";
                    },
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Colors.white
                      ),
                      hintText: S.of(context).IP,
                      labelText: S.of(context).IP,
                    ),
                  ),
                ),

                const Divider(
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                  onPressed: () {
                    editData(controllernombreAula.text, controllerdirCam.text);
                    Navigator.pop(context, true);
                  },
                  child: Text(S.of(context).saveEditData, style: const TextStyle(color: Colors.white),),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}