import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/quadra_model.dart';

class QuadraRepository {
  Future<void> salvar(QuadraModel quadra) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var col = firestore.collection("quadras");

    if (quadra.id != null) {
      var doc = await col.doc(quadra.id).get();
      await col.doc(quadra.id).update(quadra.toJson());
    } else {
      var doc = await col.add(quadra.toJson());
      doc.update({'id': doc.id});
    }

    if (quadra.imagem != null) {
      var filename = quadra.id! + ".jpg";
      var ref = FirebaseStorage.instance.ref(filename);
      await ref.putData(base64Decode(quadra.imagem!));
      var url = await ref.getDownloadURL();
      await col.doc(quadra.id).update({'Imagem': url});
    }
  }

  Future<List<QuadraModel>> listar() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> col =
        firestore.collection("quadras");
    QuerySnapshot<Map<String, dynamic>> doc = await col.get();
    return doc.docs.map((e) => QuadraModel.fromMap(e.data())).toList();
  }

  Future<void> sair() async {
    await FirebaseAuth.instance.signOut();
  }
}
