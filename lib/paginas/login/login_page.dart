import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Home/home_page.dart';
import '../../models/usuario_model.dart';
import 'login_widget.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UsuarioModel? usuario;

  autenticacao() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('Usuário fez logout!');
        setState(() {
          usuario = null;
        });
      } else {
        print('Usuario fez SigIn!');
        var snapshot =
            FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
        var fbUser = (await snapshot.get()).data();
        setState(() {
          usuario = UsuarioModel(
              id: user.uid,
              nome: fbUser!['nome'],
              email: user.email,
              foto: fbUser['foto'] ?? "");
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    autenticacao();
  }

  @override
  Widget build(BuildContext context) {
    return usuario == null ? LoginWidget() : HomePage(usuario);
  }
}
