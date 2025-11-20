import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;
    final isTablet = size.width < 1100 && size.width >= 700;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
            ? 60
            : 80,
        vertical: isMobile ? 30 : 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ---------- TÍTULO PRINCIPAL ----------
          Text(
            'El ecosistema digital integral\npara clínicas veterinarias y\ndueños de mascotas',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile
                  ? 26
                  : isTablet
                  ? 36
                  : 44,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 20),

          // ---------- SUBTÍTULO ----------
          Text(
            'Simplifica la gestión de tu clínica, conecta con dueños de mascotas y fortalece tu comunidad veterinaria con nuestra plataforma innovadora.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 15 : 18,
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          // ---------- IMAGEN INFERIOR ----------
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/vet_dashboard.png',
                fit: BoxFit.contain,
                width: isMobile
                    ? size.width * 0.7
                    : isTablet
                    ? size.width * 0.55
                    : size.width * 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
