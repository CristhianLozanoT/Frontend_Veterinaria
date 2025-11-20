import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  String? errorMsg;

  void handleLogin() async {
    setState(() {
      loading = true;
      errorMsg = null;
    });

    final ok = await ApiService.login(
      emailCtrl.text.trim(),
      passCtrl.text.trim(),
    );

    setState(() => loading = false);

    if (!ok) {
      setState(() => errorMsg = "Correo o contraseña incorrectos");
      return;
    }

    final role = ApiService.user?["role"];

    if (role == "administrador") {
      Navigator.pushReplacementNamed(context, "/admin");
    } else if (role == "veterinario") {
      Navigator.pushReplacementNamed(context, "/vet");
    } else {
      Navigator.pushReplacementNamed(context, "/assistant");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      body: Center(
        child: Container(
          width: isMobile ? size.width * 0.9 : 950,
          height: isMobile ? null : 600,
          margin: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isMobile
              ? _mobileView(context)
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 40,
                        ),
                        child: _formSection(context),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/vet_login.png',
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _formSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡Bienvenido!',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ingresa tus datos para acceder a tu cuenta y disfrutar de todas las funciones del sistema.',
          style: GoogleFonts.inter(color: Colors.black54, fontSize: 15),
        ),
        const SizedBox(height: 30),

        TextField(
          controller: emailCtrl,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: passCtrl,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(value: false, onChanged: (_) {}),
                const Text('Recordar sesión'),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '¿Olvidó su contraseña?',
                style: GoogleFonts.inter(color: Colors.teal[700]),
              ),
            ),
          ],
        ),

        if (errorMsg != null) ...[
          const SizedBox(height: 10),
          Text(errorMsg!, style: const TextStyle(color: Colors.red)),
        ],

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: loading ? null : handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Iniciar sesión',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _mobileView(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.asset('assets/images/vet_login.png', fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: _formSection(context),
        ),
      ],
    );
  }
}
