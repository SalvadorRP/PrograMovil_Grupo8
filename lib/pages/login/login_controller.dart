import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/usuario.dart';
import '../../pages/menu/menu_page.dart';
import '../../services/auth_local_service.dart';
import '../../services/mock_user_service.dart';
import 'crear_password_page.dart';

class LoginController extends GetxController {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final MockUserService _mockUserService = MockUserService();
  final AuthLocalService _authLocalService = AuthLocalService();

  final RxBool obscurePassword = true.obs;

  // controla si se muestra o no el campo contraseña
  final RxBool mostrarPassword = false.obs;

  // usuario validado por código
  Usuario? usuarioValidado;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Paso 1: validar código
  Future<void> validarCodigo() async {
    final codigo = codigoController.text.trim();

    if (codigo.isEmpty) {
      _mostrarDialogo(
        titulo: 'Código requerido',
        mensaje: 'Ingrese su código universitario.',
      );
      return;
    }

    final Usuario? usuario =
        await _mockUserService.buscarUsuarioPorCodigo(codigo);

    // Si no existe
    if (usuario == null) {
      _mostrarDialogo(
        titulo: 'Acceso denegado',
        mensaje: 'El código universitario no está registrado.',
      );
      return;
    }

    // Si existe, guardamos el usuario
    usuarioValidado = usuario;

    // Revisamos si ya tiene contraseña
    final bool tienePassword =
        await _authLocalService.tienePassword(codigo);

    // Si no tiene contraseña, lo mandamos a crearla
    if (!tienePassword) {
      Get.to(
        () => CrearPasswordPage(usuario: usuario),
      );
      return;
    }

    // Si sí tiene contraseña, mostramos el campo contraseña
    mostrarPassword.value = true;
  }

  /// Paso 2: iniciar sesión con contraseña
  Future<void> iniciarSesion() async {
    final codigo = codigoController.text.trim();
    final password = passwordController.text.trim();

    if (codigo.isEmpty) {
      _mostrarDialogo(
        titulo: 'Código requerido',
        mensaje: 'Ingrese su código universitario.',
      );
      return;
    }

    if (password.isEmpty) {
      _mostrarDialogo(
        titulo: 'Contraseña requerida',
        mensaje: 'Ingrese su contraseña para continuar.',
      );
      return;
    }

    final bool passwordCorrecta =
        await _authLocalService.validarPassword(
      codigo: codigo,
      password: password,
    );

    if (!passwordCorrecta) {
      _mostrarDialogo(
        titulo: 'Contraseña incorrecta',
        mensaje: 'La contraseña ingresada no es válida.',
      );
      return;
    }

    if (usuarioValidado == null) {
      final Usuario? usuario =
          await _mockUserService.buscarUsuarioPorCodigo(codigo);

      if (usuario == null) {
        _mostrarDialogo(
          titulo: 'Acceso denegado',
          mensaje: 'El código universitario no está registrado.',
        );
        return;
      }

      usuarioValidado = usuario;
    }

    Get.offAll(
      () => MenuPage(
        usuarioNombre: usuarioValidado!.nombre,
      ),
    );
  }

  void reiniciarLogin() {
    mostrarPassword.value = false;
    passwordController.clear();
    usuarioValidado = null;
  }

  void _mostrarDialogo({
    required String titulo,
    required String mensaje,
  }) {
    Get.defaultDialog(
      title: titulo,
      middleText: mensaje,
      textConfirm: 'Aceptar',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF9A0036),
      onConfirm: () => Get.back(),
    );
  }

  @override
  void onClose() {
    codigoController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}