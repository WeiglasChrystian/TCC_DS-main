// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:tcc/paginas/widgets/input_field.dart';

import '../../models/quadra_model.dart';
import '../../repositorios/quadra_repository.dart';

class QuadraForm extends StatefulWidget {
  final QuadraModel quadra;
  const QuadraForm(this.quadra, {Key? key}) : super(key: key);

  @override
  State<QuadraForm> createState() => _QuadraFormState();
}

class _QuadraFormState extends State<QuadraForm> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  QuadraModel quadra = QuadraModel();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              InputField(
                "Nome",
                Icons.autofps_select_sharp,
                false,
                initialValue: quadra.nome,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.nome = value;
                },
              ),
              InputField(
                "Endereço",
                Icons.description_outlined,
                false,
                initialValue: quadra.endereco,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.endereco = value;
                },
              ),
              InputField(
                "Bairro",
                Icons.description_outlined,
                false,
                initialValue: quadra.bairro,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.bairro = value;
                },
              ),
              InputField(
                "Número",
                Icons.description_outlined,
                false,
                initialValue: "${quadra.numero}",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.numero = int.tryParse(value ?? "0");
                },
              ),
              InputField(
                "Cidade",
                Icons.description_outlined,
                false,
                initialValue: quadra.cidade,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.cidade = value;
                },
              ),
              RaisedButton(
                color: Colors.grey,
                onPressed: () {
                  _imagemQuadra();
                },
                child: Text("Selecionar Imagem"),
              ),
              InputField(
                "Telefone",
                Icons.description_outlined,
                false,
                initialValue: "${quadra.telefone}",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.telefone = int.tryParse(value ?? "0");
                },
              ),
              InputField(
                "Hora do funcionamento ",
                Icons.description_outlined,
                false,
                initialValue: quadra.horaAberto,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.horaAberto = value;
                },
              ),
              InputField(
                "Hora do fechamento ",
                Icons.description_outlined,
                false,
                initialValue: quadra.horaFecha,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Campo não pode ficar vazio";
                  }
                  return null;
                },
                onsaved: (value) {
                  quadra.horaFecha = value;
                },
              ),
              Row(children: [
                Expanded(
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            _key.currentState!.save();
                            try {
                              await salvar(quadra);
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Falha ao Salvar!")));
                            }
                          }
                        },
                        icon: Icon(Icons.save),
                        label: Text("Salvar")))
              ])
            ],
          ),
        ),
      ),
    );
  }

  salvar(QuadraModel quadra) async {
    await QuadraRepository().salvar(quadra);
  }

  Future<void> _imagemQuadra() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

      photo!.readAsBytes().then((imagem) {
        setState(() {
          quadra.imagem = base64Encode(imagem);
        });
      });
    } catch (e) {
      print("Erro, Selecionando a foto da quadra: $e");
    }
  }
}
