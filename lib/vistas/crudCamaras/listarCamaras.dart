import 'dart:async';
import 'package:camaras_seguridad/modelos/camaras.dart';
import 'package:camaras_seguridad/vistas/crudCamaras/registroCamara.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../datos/database_helper.dart';
import '../Widgets/camarasView.dart';
import '../home/homePage.dart';
import 'detallesCamara.dart';

class ListarCamaras extends StatefulWidget {
//class ListarCamaras extends StatefulWidget {
  @override
  _ListarCamaras createState() =>  _ListarCamaras();
}

class _ListarCamaras extends State<ListarCamaras> {

  var _color = Colors.black54;
  var db;
  var result;
  late List<Camara> listCamara = List.empty(growable: true);
  late List<Camara> listCam = List.empty(growable: true);

  late FToast fToast;
  final _scrollController =  ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_listener);
    fToast = FToast();
    fToast.init(context);
    db = DatabaseHelper(); //inicializa la bd para su uso posterior
    loadCamaras();

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

  /*
    Este metodo accede a la informacion que se encuentra en la base de datos local, obteniendo todos los satelites geo, para despues mostrarlos en pantalla
   */
  void loadCamaras() async{
    List<Camara> Camaras;

    Camaras = await db.getCamaras();

    if(Camaras.isEmpty){
      _showToast("No a insertado camaras", Colors.redAccent);
    }else {
      setState((){
        listCam = Camaras; //retorna una List<Satelites>
      });
    }
  }

  Future refresh() async{
    setState((){
      loadCamaras();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
        onPressed: () => _navigateAndDisplay(context),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GridView.builder(

          itemCount: listCam.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () => _navigateAndDisplaySelection(context, index, listCam),
                child: CamaraView(listCam[index].dirCam)
            );
          }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
        ),
        ),

      )

    );
  }

  //listener para la barra de carga del listview
  _listener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // bottom
      setState(() {
        _color;
      });
    }
    if (_scrollController.offset <=
        _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      // top
      setState(() {
        _color;
      });
    }
  }

  _navigateAndDisplay(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
        context,MaterialPageRoute(
      builder: (BuildContext context) =>  AddCamara(),
    ));
    if(result == true) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

  _navigateAndDisplaySelection(BuildContext context, int index, List<Camara> listCam) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>  DetallesCamara(index: index, listCam: listCam),
          //builder: (BuildContext context) =>  DetallesCamara(index: index, listCam: listCam),
      ),
    );
    if(result == true) {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

}