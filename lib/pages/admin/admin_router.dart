import 'package:flutter/material.dart';
import 'package:frontend_veterinaria/pages/admin/admin_mascotas_page.dart';
import 'package:frontend_veterinaria/pages/admin/consultas_page.dart';
import 'package:frontend_veterinaria/pages/admin/medicamentos_page.dart';
import 'package:frontend_veterinaria/pages/admin/razas_page.dart';
import 'sidebar_admin.dart';
import 'dashboard_admin.dart';
import 'users_page.dart';
import 'appointments_page.dart';

class AdminRouter extends StatefulWidget {
  const AdminRouter({super.key});

  @override
  State<AdminRouter> createState() => _AdminRouterState();
}

class _AdminRouterState extends State<AdminRouter> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AdminDashboardPage(), // 0
    UsersPage(),          // 1
    AdminMascotasPage(),  // 2
    AppointmentsPage(),   // 3
    ConsultasPage(),      // 4
    RazasPage(),          // 5
    MedicamentosPage(),   // 6
  ];

  void _onSelectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text("Cerrar sesión"),
          ],
        ),
        content: const Text(
          "¿Estás seguro de que deseas cerrar sesión?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Cerrar sesión"),
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
          SidebarAdmin(
            selectedIndex: _selectedIndex,
            onItemSelected: _onSelectPage,
            onLogout: _logout, 
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
