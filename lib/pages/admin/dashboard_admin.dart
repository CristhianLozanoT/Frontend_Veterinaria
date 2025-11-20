import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Panel de Administración',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _statCard('Usuarios Registrados', '120', Icons.people_alt),
            _statCard('Mascotas', '85', Icons.pets),
            _statCard('Citas Programadas', '42', Icons.event),
            _statCard('Veterinarios', '12', Icons.medical_information),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.teal[700]),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
