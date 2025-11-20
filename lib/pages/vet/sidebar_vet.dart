import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarVet extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;

  const SidebarVet({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_hospital, color: Colors.teal[600]),
              const SizedBox(width: 8),
              Text(
                'Veterinario',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // MENÚ
          _menuItem(Icons.dashboard_outlined, 'Dashboard', 0),
          _menuItem(Icons.people_alt_outlined, 'Clientes', 1),
          _menuItem(Icons.pets, 'Mascotas', 2),
          _menuItem(Icons.event_note, 'Mis Citas', 3),
          _menuItem(Icons.description_outlined, 'Consultas', 4),

          const Spacer(),
          const Divider(),

          // CERRAR SESIÓN
          InkWell(
            onTap: onLogout,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Cerrar sesión",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: Colors.red[700],
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            'VetConnect v1.0',
            style: GoogleFonts.inter(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, int index) {
    final bool active = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? Colors.teal[700] : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: active ? Colors.teal[700] : Colors.black87,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
