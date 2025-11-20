import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardAssistant extends StatelessWidget {
  const DashboardAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Panel del Asistente',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width < 900 ? 1 : 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _statCard('📅', 'Citas Programadas', '12'),
            _statCard('💊', 'Productos en Stock', '45'),
            _statCard('💰', 'Facturas del Mes', '\$2.350.000'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String label, String value) {
    return Container(
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
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 10),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700])),
        ],
      ),
    );
  }
}
