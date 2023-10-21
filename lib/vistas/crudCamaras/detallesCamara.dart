
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../datos/database_helper.dart';
import '../../generated/l10n.dart';
import '../../modelos/camaras.dart';
import '../Widgets/camaraRecordView.dart';
import '../Widgets/camaraView.dart';
import 'editCamara.dart';

class DetallesCamara extends StatefulWidget {
  late List<Camara> listCam = List.empty(growable: true);
  int index;
  DetallesCamara({required this.index, required this.listCam});

  @override
  _DetailState createState() => _DetailState(listCam, index);
}

class _DetailState extends State<DetallesCamara> {
  late FToast fToast;
  late List<Camara> listCam = List.empty(growable: true);
  late int index;
  var db;
  String estadoEliminar = "";

  _DetailState(this.listCam, this.index);

  @override
  void initState() {
    db = DatabaseHelper(); //inicializa la bd para su uso posterior
    fToast = FToast();
    fToast.init(context);

    super.initState();
  }

  @override
  void dispose() {
    fToast.removeQueuedCustomToasts();
    fToast.removeCustomToast();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    context.dependOnInheritedWidgetOfExactType();
    fToast.removeQueuedCustomToasts();
    super.didChangeDependencies();
  }

  /*
    Este metodo accede a la informacion que se encuentra en la base de datos local, obteniendo todos los satelites geo, para despues mostrarlos en pantalla
   */
  void loadCamaras() async{
    List<Camara> Camaras;

    Camaras = await db.getCamaras();

    setState((){
      listCam = Camaras; //retorna una List<Camaras>
    });
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
              message,
              style: const TextStyle(color: Colors.white),
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

  void deleteData(int idCamara){

    db.eliminarCamaras(idCamara).catchError((Object error) => estadoEliminar = error.toString());

    if(estadoEliminar.isNotEmpty){
      _showToast(estadoEliminar, Colors.redAccent);
    }else{
      _showToast(S.of(context).delOk, Colors.greenAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Center(child:
        Text(listCam[index].nombreCamara, style: TextStyle(color: Colors.grey),)
        ),
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext bContext){
              return  [
                PopupMenuItem(
                  value: "editar",
                  child: Text(S.of(context).editCam, style: const TextStyle(color: Colors.black87)),
                ),
                PopupMenuItem(
                  value: "eliminar",
                  child: Text(S.of(context).delCam, style: const TextStyle(color: Colors.black87)),
                )
              ];
              },
            onSelected: (value){
              setState((){
                if(value.toString() == 'editar'){
                  _navigateAndDisplay(context);
                }else{
                  confirm();
                }
              });
            },
            color: Colors.grey,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 400,
                width: 400,
                child: SizedBox(
                    //child: camaraRecordView(listCam[index].dirCam)),
                    child: camaraView(listCam[index].dirCam)),
              ),

              const Divider(),

            ],
          ),
        ),
      ),
    );
  }

  _navigateAndDisplay(BuildContext context) async{
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
        context,MaterialPageRoute(
      builder: (BuildContext context) => EditCamara(index: index, listCam: listCam))
    );
    if(result == true) {
      loadCamaras();
    }
  }

  void confirm (){
    AlertDialog alertDialog = AlertDialog(
      content: Text("${S.of(context).askDel}${listCam[index].nombreCamara}?", style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w600,)),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      actions: <Widget>[
        TextButton(
          child: Text(S.of(context).delCam,style: const TextStyle(color: Colors.black,fontSize: 18)),
          onPressed: () {

            deleteData(listCam[widget.index].idCamara);
            Navigator.of(context).pop();
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child:Text(S.of(context).cancelDel,style: const TextStyle(color: Colors.black,fontSize: 18)),
          onPressed: ()=> Navigator.of(context, rootNavigator: true).pop(),
        ),
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}