import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tcc/models/usuario_model.dart';

import '../../models/agenda_model.dart';
import '../../repositorios/agenda_repository.dart';

class MinhaAgenda extends StatefulWidget {
  final UsuarioModel? usuario;

  const MinhaAgenda(this.usuario, {Key? key}) : super(key: key);

  @override
  State<MinhaAgenda> createState() => _MinhaAgendaState();
}

class _MinhaAgendaState extends State<MinhaAgenda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Agenda", textAlign: TextAlign.center),
      ),
      body: FutureBuilder<List<AgendaModel>>(
          future: AgendaRepository().listar(usuarioId: widget.usuario!.id),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Uint8List imagedata = base64Decode(
                          snapshot.data![index].quadra.imagem ?? "");

                      return ListTile(
                        leading: SizedBox(
                            height: 100,
                            width: 100,
                            child: Image(
                              image: MemoryImage(imagedata),
                              fit: BoxFit.cover,
                            )),
                        title: Text(snapshot.data![index].quadra.nome ?? ""),
                        subtitle: Text(
                            "${snapshot.data![index].horario.toString().substring(0, 16)} - ${snapshot.data![index].quadra.endereco} - ${snapshot.data![index].quadra.bairro} - ${snapshot.data![index].quadra.cidade}"),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Deseja cancelar o agendamento?"),
                                content: Text(
                                    "Você irá apagar todos os dados do agendamento"),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        await AgendaRepository()
                                            .delete(snapshot.data![index].id!);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Text("Sim")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Não")),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    });
          }),
    );
  }
}
