import 'package:flutter/material.dart';
import 'package:tcc/paginas/quadra_page/quadra_form.dart';
import '../../models/quadra_model.dart';

class QuadraPage extends StatelessWidget {
  final QuadraModel quadra;
  const QuadraPage(this.quadra, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Quadra"),
      ),
      body: QuadraForm(quadra),
    );
  }
}
