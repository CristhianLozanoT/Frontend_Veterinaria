import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormConsultationPage extends StatefulWidget {
  final Map<String, dynamic>? consulta;
  const FormConsultationPage({super.key, this.consulta});

  @override
  State<FormConsultationPage> createState() => _FormConsultationPageState();
}

class _FormConsultationPageState extends State<FormConsultationPage> {
  late TextEditingController petCtrl;
  late TextEditingController dateCtrl;
  late TextEditingController dxCtrl;

  final TextEditingController medCtrl = TextEditingController();
  List<String> meds = [];
  String estado = 'Pendiente';

  @override
  void initState() {
    super.initState();
    final c = widget.consulta;
    petCtrl = TextEditingController(text: c?['mascota']);
    dateCtrl = TextEditingController(text: c?['fecha']);
    dxCtrl = TextEditingController(text: c?['diagnostico']);
    meds = List<String>.from(c?['medicamentos'] ?? <String>[]);
    estado = c?['estado'] ?? 'Pendiente';
  }

  void _addMed() {
    if (medCtrl.text.trim().isEmpty) return;
    setState(() {
      meds.add(medCtrl.text.trim());
      medCtrl.clear();
    });
  }

  void _removeMed(int index) {
    setState(() => meds.removeAt(index));
  }

  void _save() {
    if (petCtrl.text.trim().isEmpty ||
        dateCtrl.text.trim().isEmpty ||
        dxCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa los campos obligatorios.')),
      );
      return;
    }

    final data = <String, dynamic>{
      'mascota': petCtrl.text.trim(),
      'fecha': dateCtrl.text.trim(),
      'diagnostico': dxCtrl.text.trim(),
      'estado': estado,
      'medicamentos': meds,
    };

    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.consulta != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          editing ? 'Editar Consulta' : 'Nueva Consulta',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _input('Mascota', petCtrl),
            _input('Fecha (AAAA-MM-DD)', dateCtrl),
            _input('Diagnóstico', dxCtrl, maxLines: 3),

            const SizedBox(height: 20),
            Text(
              'Medicamentos recetados',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: medCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre / Dosis / Frecuencia',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addMed(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addMed,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 12),
            ...List.generate(meds.length, (i) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  title: Text(meds[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removeMed(i),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: estado,
              items: const [
                DropdownMenuItem(value: 'Pendiente', child: Text('Pendiente')),
                DropdownMenuItem(value: 'Terminada', child: Text('Terminada')),
              ],
              onChanged: (v) => setState(() => estado = v!),
              decoration: const InputDecoration(
                labelText: 'Estado de la consulta',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(editing ? 'Guardar cambios' : 'Guardar consulta'),
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
