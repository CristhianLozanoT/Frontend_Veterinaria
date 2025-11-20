import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/consulta_medicamentos_service.dart';
import '../../services/medicamentos_service.dart';

class VetConsultaMedicamentosPage extends StatefulWidget {
  final int consultaId;

  const VetConsultaMedicamentosPage({super.key, required this.consultaId});

  @override
  State<VetConsultaMedicamentosPage> createState() =>
      _VetConsultaMedicamentosPageState();
}

class _VetConsultaMedicamentosPageState
    extends State<VetConsultaMedicamentosPage> {
  bool loading = true;
  List<dynamic> medicamentosConsulta = [];
  List<dynamic> medicamentosCatalogo = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);

    try {
      medicamentosConsulta =
          await ConsultaMedicamentosService.listarMedicamentos(
            widget.consultaId,
          );

      medicamentosCatalogo = await MedicamentosService.listarMedicamentos();
    } catch (e) {
      _msg("Error cargando medicamentos: $e");
    }

    setState(() => loading = false);
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _showAgregarDialog() {
    int? medicamentoId;
    String cantidad = "";

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setInner) => AlertDialog(
          title: Text(
            "Agregar Medicamento",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Medicamento",
                    border: OutlineInputBorder(),
                  ),
                  items: medicamentosCatalogo.map((m) {
                    return DropdownMenuItem<int>(
                      value: m["id"],
                      child: Text("${m["nombre"]} — \$${m["precio"]}"),
                    );
                  }).toList(),
                  onChanged: (v) => setInner(() => medicamentoId = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Cantidad",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => cantidad = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (medicamentoId == null || cantidad.isEmpty) {
                  _msg("Completa todos los campos");
                  return;
                }

                try {
                  await ConsultaMedicamentosService.agregar(
                    consultaId: widget.consultaId,
                    medicamentoId: medicamentoId!,
                    cantidad: int.parse(cantidad),
                  );

                  Navigator.pop(context);
                  cargar();
                } catch (e) {
                  _msg("Error: $e");
                }
              },
              child: const Text("Agregar"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditarDialog(Map<String, dynamic> item) {
    String cantidad = item["cantidad"].toString();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setInner) => AlertDialog(
          title: Text(
            "Editar Cantidad",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 300,
            child: TextFormField(
              initialValue: cantidad,
              decoration: const InputDecoration(
                labelText: "Cantidad",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => cantidad = v,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ConsultaMedicamentosService.actualizar(
                    consultaId: item["consulta_id"],
                    medicamentoId: item["medicamento_id"],
                    cantidad: int.parse(cantidad),
                  );
                  Navigator.pop(context);
                  cargar();
                } catch (e) {
                  _msg("Error: $e");
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Medicamentos de la Consulta",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _showAgregarDialog,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : medicamentosConsulta.isEmpty
          ? const Center(child: Text("No hay medicamentos asignados"))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Medicamento")),
                    DataColumn(label: Text("Cantidad")),
                    DataColumn(label: Text("Acciones")),
                  ],
                  rows: medicamentosConsulta.map((m) {
                    final med = medicamentosCatalogo.firstWhere(
                      (x) => x["id"] == m["medicamento_id"],
                      orElse: () => null,
                    );

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            med != null
                                ? med["nombre"]
                                : "ID ${m["medicamento_id"]}",
                          ),
                        ),
                        DataCell(Text("${m["cantidad"]}")),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () => _showEditarDialog(m),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  try {
                                    await ConsultaMedicamentosService.eliminar(
                                      m["consulta_id"],
                                      m["medicamento_id"],
                                    );
                                    cargar();
                                  } catch (e) {
                                    _msg("Error: $e");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
