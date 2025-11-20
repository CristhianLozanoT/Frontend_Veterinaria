import 'package:flutter/material.dart';
import 'sidebar_vet.dart';
import 'dashboard_vet.dart';
import 'vet_clientes_page.dart';
import 'vet_mascotas_page.dart';
import 'vet_citas_page.dart';
import 'vet_consultas_page.dart';
import 'vet_razas_page.dart';
import 'vet_consulta_medicamentos_page.dart';
import 'vet_citas_page.dart';

class VetRouter extends StatefulWidget {
  const VetRouter({super.key});

  @override
  State<VetRouter> createState() => _VetRouterState();
}

class _VetRouterState extends State<VetRouter> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    VetDashboardPage(),
    VetClientesPage(),
    VetMascotasPage(),
    VetCitasPage(),
    VetConsultasPage(),
  ];

  void _onSelectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text("Cerrar Sesión"),
          ],
        ),
        content: const Text("¿Seguro que deseas cerrar sesión?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Salir"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarVet(
            selectedIndex: _selectedIndex,
            onItemSelected: _onSelectPage,
            onLogout: _logout,
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
