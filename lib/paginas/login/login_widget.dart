import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/paginas/usuario/usuario_page.dart';

import '../widgets/input_field.dart';
import '../../models/usuario_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool ver = false;
  UsuarioModel usuario = UsuarioModel();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('image/society.png', fit: BoxFit.cover),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(0.0),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(fontSize: 50, height: 0),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 80,
                          height: 100,
                          child: Image.asset("image/bola.png"),
                        ),
                      ],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            InputField(
                              "Email",
                              Icons.email,
                              false,
                              onsaved: (email) => usuario.email = email,
                            ),
                            InputField(
                              "Senha",
                              Icons.password,
                              true,
                              onsaved: (senha) => usuario.senha = senha,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _botaoEntrar(),
                            _botaoCadastar(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _botaoEntrar() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                onPressed: () {
                  _login();
                },
                child: Text("Entrar"))),
      ],
    );
  }

  _botaoCadastar() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Não tem um conta ?    "),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => UsuarioPage()));
            },
            child: Text(
              "Cadastre-se",
              style: TextStyle(fontSize: 17),
            ))
      ]),
    );
  }

  Future<void> _login() async {
    _key.currentState!.save();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: usuario.email!, password: usuario.senha!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Email desconhecido!")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Senha incorreta!")));
      }
    }
  }
}
