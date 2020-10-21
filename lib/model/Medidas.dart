class Medidas{

  int id;
  double peso;
  String data;

  Medidas (this.peso, this.data);

  Medidas.fromMap(Map map){

    this.id = map["id"];
    this.peso = map["peso"];
    this.data = map["dataHorario"];

  }

  Map toMap(){

    Map<String, dynamic> map = {
      "peso" : this.peso,
      "dataHorario" : this.data,
    };

    if(this.id != null){
      map["id"] = this.id;
    }

    return map;

  }


}