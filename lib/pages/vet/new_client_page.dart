import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewClientPage extends StatefulWidget {
  const NewClientPage({super.key});

  @override
  State<NewClientPage> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController ownerCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController petNameCtrl = TextEditingController();
  final TextEditingController petSpeciesCtrl = TextEditingController();
  final TextEditingController petDiagnosisCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text('Registrar Cliente y Mascota',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w700, color: Colors.teal[700])),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Datos del Cliente',
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              _input('Nombre completo', ownerCtrl),
              _input('Correo electrónico', emailCtrl),
              _input('Teléfono', phoneCtrl),
              const SizedBox(height: 30),
              Text('Datos de la Mascota',
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              _input('Nombre de la mascota', petNameCtrl),
              _input('Especie o raza', petSpeciesCtrl),
              _input('Diagnóstico inicial', petDiagnosisCtrl, maxLines: 3),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Cliente y mascota registrados')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Guardar registro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }
}
