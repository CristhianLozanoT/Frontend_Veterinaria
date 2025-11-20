import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';


class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- FILA PRINCIPAL ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LOGO
              Row(
                children: [
                  Icon(Icons.pets, color: Colors.teal[600], size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'VetConnect',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.teal[600],
                    ),
                  ),
                ],
              ),

              // Si es escritorio/tablet: mostrar menú completo
              if (!isMobile)
                Row(
                  children: [
                    const SizedBox(width: 30),
                    Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 16),
                    _accountMenu(context), 
                  ],
                )
              else
                // Si es móvil: icono de menú
                IconButton(
                  icon: Icon(
                    _menuOpen ? Icons.close : Icons.menu,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      _menuOpen = !_menuOpen;
                    });
                  },
                ),
            ],
          ),

          // ---------- MENÚ MÓVIL DESPLEGABLE ----------
          if (isMobile && _menuOpen)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _mobileItem('Inicio', true),
                  _mobileItem('Servicios', false),
                  _mobileItem('Comunidad', false),
                  _mobileItem('Contacto', false),
                  const SizedBox(height: 12),
                  _accountMenu(context, isMobile: true), 
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------- ITEM DE MENÚ (ESCRITORIO) ----------
  Widget _navItem(String text, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.teal[600] : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ---------- ITEM DE MENÚ (MÓVIL) ----------
  Widget _mobileItem(String text, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.teal[600] : Colors.black87,
        ),
      ),
    );
  }

  // ---------- MENÚ DE CUENTA (ICONO) ----------
    // ---------- MENÚ DE CUENTA (ICONO) ----------
  Widget _accountMenu(BuildContext context, {bool isMobile = false}) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.account_circle_outlined, color: Colors.black54),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 6,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Bienvenido!',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selecciona una opción:',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
              ),
              const Divider(),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: Center(
            child: Text(
              'Iniciar sesión',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.teal[700],
              ),
            ),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else if (value == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterPage()),
          );
        }
      },
    );
  }
}
