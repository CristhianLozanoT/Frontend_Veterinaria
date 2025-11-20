import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VetDashboardPage extends StatelessWidget {
  const VetDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('Panel del Veterinario',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.teal[700])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _card(Icons.person_add_alt_1, 'Registrar nuevo cliente'),
            _card(Icons.assignment_outlined, 'Ver consultas pendientes'),
            _card(Icons.history, 'Consultas terminadas'),
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String label) {
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
          Icon(icon, size: 40, color: Colors.teal),
          const SizedBox(height: 12),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
