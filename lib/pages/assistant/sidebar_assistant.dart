import 'package:flutter/material.dart';

class SidebarAssistant extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTap;

  const SidebarAssistant({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard, 'label': 'Panel'},
      {'icon': Icons.calendar_today, 'label': 'Citas'},
      {'icon': Icons.inventory, 'label': 'Productos'},
      {'icon': Icons.receipt_long, 'label': 'Facturas'},
    ];

    return Container(
      width: 220,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Text(
            '🩺 Asistente',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          for (int i = 0; i < items.length; i++)
            ListTile(
              leading: Icon(items[i]['icon'] as IconData,
                  color: i == selectedIndex ? Colors.teal : Colors.grey),
              title: Text(
                items[i]['label'] as String,
                style: TextStyle(
                  color: i == selectedIndex ? Colors.teal : Colors.black87,
                  fontWeight: i == selectedIndex
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              onTap: () => onItemTap(i),
            ),
        ],
      ),
    );
  }
}
