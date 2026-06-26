import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/usuario.dart';

class MockUserService {
  Future<List<Usuario>> obtenerUsuarios() async {
    final String response = await rootBundle.loadString(
      'lib/data/usuarios_mock.json',
    );

    final List<dynamic> data = json.decode(response);

    return data.map((item) => Usuario.fromJson(item)).toList();
  }

  Future<Usuario?> buscarUsuarioPorCodigo(String codigo) async {
    final usuarios = await obtenerUsuarios();

    try {
      return usuarios.firstWhere(
        (usuario) => usuario.codigo == codigo,
      );
    } catch (e) {
      return null;
    }
  }
}