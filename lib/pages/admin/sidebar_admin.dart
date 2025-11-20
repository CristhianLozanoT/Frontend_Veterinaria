import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarAdmin extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;

  const SidebarAdmin({
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
          // Header del panel
          Row(
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.teal[600]),
              const SizedBox(width: 8),
              Text(
                'Panel Admin',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal[700],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Menú principal
          _menuItem(Icons.dashboard_outlined, 'Dashboard', 0),
          _menuItem(Icons.people_alt_outlined, 'Usuarios', 1),
          _menuItem(Icons.pets, 'Mascotas', 2),
          _menuItem(Icons.event_note, 'Citas', 3),
          _menuItem(Icons.description_outlined, 'Consultas', 4),
          _menuItem(Icons.pets_rounded, "Razas", 5),
          _menuItem(Icons.medication, 'Medicamentos', 6),

          const Spacer(),
          const Divider(),
          const SizedBox(height: 10),

          // Cerrar sesión — Nuevo ítem
          InkWell(
            onTap: onLogout,
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  "Cerrar sesión",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Footer
          Text(
            'Versión 1.0.0',
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
