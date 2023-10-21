import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../modelos/camaras.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if(_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "camaras.db");

    var exists = await databaseExists(path);
    if (!exists) {      // Debería ocurrir solo la primera vez que inicia su aplicación
      // Asegúrese de que exista el directorio principal
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }else{
      _db = await openDatabase(path, version: 1,);
    }
    _db = await openDatabase(path, version: 1,);
    return _db;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Camara(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, ipCam TEXT)");

  }

  Future<int> registroAula(Camara camara) async {
    var dbClient = await db;
    int res = await dbClient!.insert("Camara", camara.toMap());
    return res;
  }

  Future registroCamaras(String nombreAula, String dirCam) async {
    var dbClient = await initDb();
    //Mediante una consulta SQL se almacena un nuevo registro
    await dbClient.rawQuery('INSERT INTO Camara (nombre, ipCam) VALUES("${nombreAula}", "${dirCam}");');

  }

  Future eliminarCamaras(int idCamara) async {
    var dbClient = await initDb();
    //Mediante una consulta SQL se elimina en una lista los datos obtenidos
    await dbClient.rawQuery('DELETE FROM Camara WHERE id = ${idCamara};');
  }

  Future actualizarCamaras(int idCamara, String nombreCamara, String dirCam) async {
    var dbClient = await initDb();
    //Mediante una consulta SQL se elimina en una lista los datos obtenidos
    await dbClient.rawQuery('UPDATE Camara SET nombre = "${nombreCamara}", ipCam = "${dirCam}" WHERE id = ${idCamara};');
  }

  Future<List<Camara>> getCamaras() async {
    var dbClient = await initDb();
    //Mediante una consulta SQL se almacena en una lista los datos obtenidos
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Camara');
    List<Camara> camaras = List.empty(growable: true);
    //recorremos la lista y agregan los datos a la lista de satelites que se creo anteriormente
    for (int i = 0; i < list.length; i++) {
      camaras.add(Camara(list[i]["id"], list[i]["nombre"], list[i]["ipCam"]));
    }
    return camaras;
  }


}