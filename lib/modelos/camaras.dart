class Camara {
  late final int idCamara;
  late final String nombreCamara;
  late final String dirCam;

  Camara(
      this.idCamara,
      this.nombreCamara,
      this.dirCam,
      );


  /*
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["idCamara"] = idCamara;
    map["nombreCamara"] = nombreCamara;
    map["dirCam"] = dirCam;

    return map;
  }

   */

  Camara.fromMap(Map res){
    idCamara = res["idCamara"];
    nombreCamara = res["nombreCamara"];
    dirCam = res["dirCam"];
  }

  Map<String, Object?> toMap() {
    return {
      "idCamara":idCamara,
      "nombreCamara":nombreCamara,
      "dirCam":dirCam
    };
  }
}