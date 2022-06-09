import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tcc/paginas/agendamento/minha_agenda.dart';
import 'package:tcc/paginas/calendario/calendario.dart';
import 'package:tcc/paginas/usuario/usuario_page.dart';
import 'package:tcc/repositorios/quadra_repository.dart';
import 'package:tcc/repositorios/usuario_repository.dart';

import '../../foto_widget.dart';
import '../../models/quadra_model.dart';
import '../../models/usuario_model.dart';

import '../quadra_page/quadra_page.dart';

class HomePage extends StatelessWidget {
  final UsuarioModel? usuario;

  const HomePage(this.usuario, {Key? key}) : super(key: key);

  get style => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quadras Sport"),
      ),
      body: FutureBuilder<List<QuadraModel>>(
          future: QuadraRepository().listar(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Uint8List imagedata =
                          base64Decode(snapshot.data![index].imagem ?? "");

                      return ListTile(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    Calendario(snapshot.data![index]))),
                        leading: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image(
                              image: MemoryImage(imagedata),
                              fit: BoxFit.cover,
                            )),
                        title: Text(snapshot.data![index].nome ?? ""),
                        subtitle: Text(
                            "${snapshot.data![index].endereco} - ${snapshot.data![index].bairro} - ${snapshot.data![index].cidade}"),
                      );
                    });
          }),
      drawer: Drawer(
        backgroundColor: Colors.grey,
        elevation: 5,
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  child: Card(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                                radius: 55.0,
                                backgroundImage:
                                    FotoUsuario().getFoto(usuario!)),
                            Text(usuario!.nome ?? ""),
                          ],
                        ),
                        Positioned(
                            right: 2,
                            top: 2,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          UsuarioPage(usuario: usuario)));
                                },
                                icon: Icon(Icons.edit))),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Expanded(
                    child: ListTile(
                      leading: Icon(Icons.add),
                      title: Text("Nova quadra"),
                      onTap: () {
                        var quadra = QuadraModel();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => QuadraPage(quadra)));
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text("Minha Agenda"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MinhaAgenda(usuario)));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        UsuarioRepository().sair();
                      },
                      icon: Icon(Icons.exit_to_app),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
