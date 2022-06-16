import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/agenda_model.dart';

class AgendaRepository {
  Future<void> salvar(AgendaModel agenda) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var col = firestore.collection("agendas");

    if (agenda.id != null) {
      var doc = await col.doc("${agenda.id}").get();

      await col.doc("${agenda.id}").update(agenda.toJson());
    } else {
      var doc = await col.add(agenda.toJson());
      await doc.update({'id': doc.id});
    }
  }

  Future<List<AgendaModel>> listar(
      {String? usuarioId, String? quadraId}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> col =
        firestore.collection("agendas");

    Query<Map<String, dynamic>>? query;

    if (quadraId != null) {
      query = col.where("quadra.id", isEqualTo: quadraId);
    }

    if (usuarioId != null) {
      query = col.where("usuarioId", isEqualTo: usuarioId);
    }

    QuerySnapshot<Map<String, dynamic>> docs = await query!.get();
    return docs.docs.map((e) => AgendaModel.fromMap(e.data())).toList();
  }

  Future<void> delete(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> col =
        firestore.collection("agendas");
    await col.doc(id).delete();
  }
}
