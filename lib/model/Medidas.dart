class Medidas{

  int id;
  double peso;
  String data;
  int idPerfilFk;

  Medidas ({this.peso, this.data, this.idPerfilFk});

  Medidas.fromMap(Map map){

    this.id = map["id_medidas"];
    this.peso = map["peso"];
    this.data = map["dataHorario"];
    this.idPerfilFk = map["id_perfil_fk"];

  }

  Map toMap(){

    Map<String, dynamic> map = {
      "peso" : this.peso,
      "dataHorario" : this.data,
      "id_perfil_fk" : this.idPerfilFk,
    };

    if(this.id != null){
      map["id_medidas"] = this.id;
    }

    return map;

  }


}