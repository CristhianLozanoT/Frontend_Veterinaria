import 'package:flutter/material.dart';
import 'dashboard_assistant.dart';
import 'appointments_page.dart';
import 'products_page.dart';
import 'invoices_page.dart';
import 'sidebar_assistant.dart';

class AssistantRouter extends StatefulWidget {
  const AssistantRouter({super.key});

  @override
  State<AssistantRouter> createState() => _AssistantRouterState();
}

class _AssistantRouterState extends State<AssistantRouter> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardAssistant(),
    AppointmentsPage(),
    ProductsPage(),
    InvoicesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SidebarAssistant(
            selectedIndex: _selectedIndex,
            onItemTap: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
