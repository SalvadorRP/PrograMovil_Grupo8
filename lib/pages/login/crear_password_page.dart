import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/usuario.dart';
import '../../services/auth_local_service.dart';

class CrearPasswordPage extends StatefulWidget {
  final Usuario usuario;

  const CrearPasswordPage({
    super.key,
    required this.usuario,
  });

  @override
  State<CrearPasswordPage> createState() => _CrearPasswordPageState();
}

class _CrearPasswordPageState extends State<CrearPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthLocalService _authLocalService = AuthLocalService();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> guardarPassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _mostrarDialogo('Complete ambos campos de contraseña.');
      return;
    }

    if (password.length < 6) {
      _mostrarDialogo(
        'La contraseña debe tener al menos 6 caracteres.',
      );
      return;
    }

    if (password != confirmPassword) {
      _mostrarDialogo('Las contraseñas no coinciden.');
      return;
    }

    await _authLocalService.guardarPassword(
      codigo: widget.usuario.codigo,
      password: password,
    );

    Get.defaultDialog(
      title: 'Contraseña creada',
      middleText:
          'Tu contraseña se guardó correctamente. Ahora inicia sesión con tu código y contraseña.',
      textConfirm: 'Ir al login',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF9A0036),
      onConfirm: () {
        Get.back(); // cierra dialog
        Get.back(); // vuelve al login
      },
    );
  }

  void _mostrarDialogo(String mensaje) {
    Get.defaultDialog(
      title: 'ULima Café',
      middleText: mensaje,
      textConfirm: 'Aceptar',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF9A0036),
      onConfirm: () => Get.back(),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('Crear contraseña'),
        backgroundColor: const Color(0xFF9A0036),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, ${widget.usuario.nombre}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tu código ${widget.usuario.codigo} fue validado. Ahora crea tu contraseña para ingresar a ULima Café.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                'Nueva contraseña',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Mínimo 6 caracteres',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Confirmar contraseña',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: confirmPasswordController,
                obscureText: obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Repite tu contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: guardarPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9A0036),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Guardar contraseña',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}