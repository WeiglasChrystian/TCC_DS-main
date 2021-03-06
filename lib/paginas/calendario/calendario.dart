import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/agenda_model.dart';
import 'package:tcc/models/usuario_model.dart';
import 'package:tcc/repositorios/agenda_repository.dart';

import '../../models/quadra_model.dart';

class Calendario extends StatefulWidget {
  QuadraModel quadraModel;
  UsuarioModel usuario;
  Calendario(this.quadraModel, this.usuario, {Key? key}) : super(key: key);

  @override
  _CalendarioState createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  DateTime _date = DateTime.now();

  var dataformato;
  var agenda = <AgendaModel>[];
  var horarios = <AgendaModel>[];
  var carregando = false;

  @override
  void initState() {
    super.initState();

    _carregarHorarios(_date, widget.quadraModel);
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime(2040),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        _carregarHorarios(_date, widget.quadraModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            dataformato = DateFormat('dd/MM/yyyy').format(_date),
          ),
          actions: [
            GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.calendar_month,
                    size: 35,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectDate(context);
                  });
                }),
          ],
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: carregando
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : Wrap(
                  children: horarios.map((e) {
                  return Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onSurface: Colors.grey,
                          elevation: 10,
                        ),
                        child:
                            Text(e.horario.toString().substring(11, 13) + "h"),
                        onPressed: e.id != null
                            ? null
                            : () async {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title:
                                                Text("Confirmar Agendamento?"),
                                            actions: [
                                              TextButton(
                                                  child: Text("Sim"),
                                                  onPressed: () async {
                                                    try {
                                                      setState(() {
                                                        carregando = true;
                                                      });
                                                      await AgendaRepository()
                                                          .salvar(e);
                                                      _carregarHorarios(_date,
                                                          widget.quadraModel);
                                                    } catch (e) {
                                                      carregando = false;
                                                      print(e);
                                                    }
                                                    Navigator.pop(context);
                                                  }),
                                              TextButton(
                                                  child: Text("N??o"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  })
                                            ]));
                              },
                      ));
                }).toList()),
        )));
  }

  List<AgendaModel> _geraHorarios(DateTime dia, QuadraModel quadra) {
    var horarios = <AgendaModel>[];
    var dt = DateFormat('dd/MM/yyyy hh:mm');
    String diaStr = dt.format(dia).substring(0, 10);
    DateTime abre = dt.parse(diaStr + " " + quadra.horaAberto!);
    DateTime fecha = dt.parse(diaStr + " " + quadra.horaFecha!);
    for (DateTime horario = abre;
        horario.isBefore(fecha);
        horario = horario.add(Duration(hours: 1))) {
      horarios.add(AgendaModel(quadra, horario, widget.usuario.id!));
    }
    return horarios;
  }

  void _carregarHorarios(DateTime data, QuadraModel quadra) {
    setState(() {
      carregando = true;
    });

    AgendaRepository().listar(quadraId: widget.quadraModel.id).then((agendado) {
      var horas = _geraHorarios(data, widget.quadraModel);
      var _horarios = <AgendaModel>[];

      for (int d = 0; d < horas.length; d++) {
        AgendaModel? a;
        try {
          a = agendado.firstWhere(
              (element) => element.horario.isAtSameMomentAs(horas[d].horario));
        } catch (e) {}

        if (a == null) {
          _horarios.add(horas[d]);
        } else {
          _horarios.add(a);
        }
      }
      setState(() {
        horarios = _horarios;
        carregando = false;
      });
    });
  }
}
