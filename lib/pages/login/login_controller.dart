import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/menu/menu_page.dart';
import '../../services/auth_service.dart';

class LoginController extends GetxController {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  final RxBool obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

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

    final response = await _authService.login(codigo, password);

    if (response.success && response.data != null) {
      final userDict = response.data!['user'] as Map<String, dynamic>;
      final nombre = userDict['first_name'] as String? ?? 'Usuario';
      
      Get.offAll(
        () => MenuPage(
          usuarioNombre: nombre,
        ),
      );
    } else {
      _mostrarDialogo(
        titulo: 'Acceso denegado',
        mensaje: response.message ?? 'Usuario o contraseña incorrectos.',
      );
    }
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