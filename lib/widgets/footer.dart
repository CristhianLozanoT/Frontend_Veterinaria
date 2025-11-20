import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 30,
      ),
      child: Column(
        children: [
          // ---------- ENLACES PRINCIPALES ----------
          isMobile
              ? Column(
                  children: [
                    _linksRow(isMobile),
                    const SizedBox(height: 20),
                    _socialIcons(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _linksRow(isMobile),
                    _socialIcons(),
                  ],
                ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),

          // ---------- COPYRIGHT ----------
          Text(
            '© 2025 VetConnect. Todos los derechos reservados.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _linksRow(bool isMobile) {
    final links = ['Recursos', 'Legal', 'Contáctanos'];
    return Wrap(
      alignment:
          isMobile ? WrapAlignment.center : WrapAlignment.start,
      spacing: 20,
      runSpacing: 10,
      children: links
          .map(
            (text) => Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _socialIcons() {
    const icons = [
      Icons.facebook_outlined,
      Icons.linked_camera_outlined,
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      children: icons
          .map(
            (icon) => Icon(
              icon,
              color: Colors.black54,
              size: 20,
            ),
          )
          .toList(),
    );
  }
}
