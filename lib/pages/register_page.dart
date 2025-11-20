import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/vet_register.png',
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ),

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
          '¡Crea tu cuenta!',
          style: GoogleFonts.inter(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Completa tus datos personales para unirte a nuestra comunidad veterinaria.',
          style: GoogleFonts.inter(color: Colors.black54, fontSize: 15),
        ),
        const SizedBox(height: 30),

        TextField(
          decoration: InputDecoration(
            labelText: 'Nombre completo',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),

        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Registrarse',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: Colors.teal[600]!),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Iniciar sesión'),
        ),
      ],
    );
  }

  Widget _mobileView(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.asset(
            'assets/images/vet_register.png',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: _formSection(context),
        ),
      ],
    );
  }
}
