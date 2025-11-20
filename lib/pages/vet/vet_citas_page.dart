import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/vet_citas_service.dart';

class VetCitasPage extends StatefulWidget {
  const VetCitasPage({super.key});

  @override
  State<VetCitasPage> createState() => _VetCitasPageState();
}

class _VetCitasPageState extends State<VetCitasPage> {
  bool loading = true;
  List<dynamic> citas = [];

  @override
  void initState() {
    super.initState();
    cargarCitas();
  }

  Future<void> cargarCitas() async {
    try {
      citas = await VetCitasService.listarCitasVeterinario();
    } catch (e) {
      _msg("Error cargando citas: $e");
    }

    setState(() => loading = false);
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  
  
  
  void _showCambiarEstadoDialog(Map<String, dynamic> cita) {
    String estado = cita["estado"] ?? "pendiente";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Actualizar Estado"),
        content: DropdownButtonFormField<String>(
          value: estado,
          decoration: const InputDecoration(
            labelText: "Estado",
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: "pendiente",
              child: Text("Pendiente"),
            ),
            DropdownMenuItem(
              value: "completada",
              child: Text("Completada"),
            ),
            DropdownMenuItem(
              value: "cancelada",
              child: Text("Cancelada"),
            ),
          ],
          onChanged: (v) {
            estado = v!;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () async {
              try {
                await VetCitasService.actualizarEstadoCita(
                  citaId: cita["id"],
                  estado: estado,
                );

                Navigator.pop(context);
                cargarCitas();
                _msg("Estado actualizado");
              } catch (e) {
                _msg("Error: $e");
              }
            },
            child: const Text("Guardar"),
          )
        ],
      ),
    );
  }

  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Mis Citas",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: citas.isEmpty
                  ? const Center(child: Text("No tienes citas registradas"))
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Fecha")),
                          DataColumn(label: Text("Hora")),
                          DataColumn(label: Text("Estado")),
                          DataColumn(label: Text("Acciones")),
                        ],
                        rows: List.generate(citas.length, (i) {
                          final c = citas[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(c["fecha"] ?? "--")),
                              DataCell(Text(c["hora"] ?? "--")),
                              DataCell(Text(c["estado"] ?? "--")),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.teal),
                                  onPressed: () => _showCambiarEstadoDialog(c),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
            ),
    );
  }
}
