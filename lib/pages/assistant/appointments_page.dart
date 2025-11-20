import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, dynamic>> citas = [
    {
      'descripcion': 'Chequeo general de Buddy',
      'solicitante': 'Sofía Martínez',
      'fecha': '2025-11-15',
      'hora': '10:00 AM'
    },
  ];

  void _openDialog({int? index}) {
    final editing = index != null;
    final cita = editing ? citas[index!] : null;
    final descCtrl = TextEditingController(text: cita?['descripcion']);
    final nombreCtrl = TextEditingController(text: cita?['solicitante']);
    final fechaCtrl = TextEditingController(text: cita?['fecha']);
    final horaCtrl = TextEditingController(text: cita?['hora']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editing ? 'Editar Cita' : 'Nueva Cita'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _input('Descripción de la cita', descCtrl),
              _input('Nombre del solicitante', nombreCtrl),
              _input('Fecha (AAAA-MM-DD)', fechaCtrl),
              _input('Hora (HH:MM AM/PM)', horaCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              final data = {
                'descripcion': descCtrl.text.trim(),
                'solicitante': nombreCtrl.text.trim(),
                'fecha': fechaCtrl.text.trim(),
                'hora': horaCtrl.text.trim(),
              };
              setState(() {
                if (editing) {
                  citas[index!] = data;
                } else {
                  citas.add(data);
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteAppointment(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cita'),
        content: const Text('¿Deseas eliminar esta cita?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => citas.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Agenda de Citas',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.teal[700])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () => _openDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Agendar nueva cita'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: citas.isEmpty
                  ? const Center(child: Text('No hay citas registradas.'))
                  : DataTable(
                      columns: const [
                        DataColumn(label: Text('Descripción')),
                        DataColumn(label: Text('Solicitante')),
                        DataColumn(label: Text('Fecha')),
                        DataColumn(label: Text('Hora')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: List.generate(citas.length, (i) {
                        final c = citas[i];
                        return DataRow(cells: [
                          DataCell(Text(c['descripcion'])),
                          DataCell(Text(c['solicitante'])),
                          DataCell(Text(c['fecha'])),
                          DataCell(Text(c['hora'])),
                          DataCell(Row(children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.teal),
                              onPressed: () => _openDialog(index: i),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => _deleteAppointment(i),
                            ),
                          ])),
                        ]);
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
