import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/usuario_model.dart';


class FotoUsuario{
  getFoto(UsuarioModel usuario) {
    if (usuario.foto!=null) {
      if (usuario.foto!.contains("https")) {
        return NetworkImage(usuario.foto!);
      } else {
        return MemoryImage(base64Decode(usuario.foto!));
      }
    } else {
      return ExactAssetImage("image/pessoa.jpg");
    }
    
  }
}