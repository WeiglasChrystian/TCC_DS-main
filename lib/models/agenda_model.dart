import 'package:tcc/models/quadra_model.dart';

class AgendaModel {
  QuadraModel quadra;
  DateTime horario;
  String? id;
  String usuarioId;

  AgendaModel(this.quadra, this.horario, this.usuarioId, {this.id});

  Map<String, dynamic> toJson() {
    return {
      "quadra": quadra.toJson(),
      "horario": horario,
      "id": id,
      "usuarioId": usuarioId
    };
  }

  factory AgendaModel.fromMap(Map<String, dynamic> map) {
    var horario =
        DateTime.fromMillisecondsSinceEpoch(map['horario'].seconds * 1000);
    return AgendaModel(
        QuadraModel.fromMap(map['quadra']), horario, map['usuarioId'],
        id: map['id']);
  }
}
