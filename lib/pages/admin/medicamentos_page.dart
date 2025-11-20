import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/medicamentos_service.dart';
import 'package:frontend_veterinaria/widgets/dialog_confirm_delete.dart';

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({super.key});

  @override
  State<MedicamentosPage> createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  List<dynamic> medicamentos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    setState(() => loading = true);

    try {
      medicamentos = await MedicamentosService.listarMedicamentos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }
  void _showModal({Map<String, dynamic>? medicamento}) {
    final editing = medicamento != null;

    String nombre = medicamento?["nombre"] ?? "";
    String precio = medicamento?["precio"]?.toString() ?? "";

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setInner) {
          return AlertDialog(
            title: Text(
              editing ? "Editar Medicamento" : "Nuevo Medicamento",
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: nombre,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setInner(() => nombre = v),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: precio,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Precio",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setInner(() => precio = v),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text(editing ? "Guardar" : "Crear"),
                onPressed: () async {
                  if (nombre.isEmpty || precio.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Todos los campos son obligatorios"),
                      ),
                    );
                    return;
                  }

                  try {
                    if (editing) {
                      await MedicamentosService.actualizarMedicamento(
                        id: medicamento!["id"],
                        nombre: nombre,
                        precio: double.tryParse(precio) ?? 0,
                      );
                    } else {
                      await MedicamentosService.crearMedicamento(
                        nombre: nombre,
                        precio: double.tryParse(precio) ?? 0,
                      );
                    }

                    Navigator.pop(context);
                    cargarDatos();
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
  void _delete(int id) async {
    try {
      await MedicamentosService.eliminarMedicamento(id);
      cargarDatos();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFD),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showModal(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : medicamentos.isEmpty
          ? const Center(child: Text("No hay medicamentos registrados"))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Precio")),
                    DataColumn(label: Text("Acciones")),
                  ],
                  rows: medicamentos.map((m) {
                    return DataRow(
                      cells: [
                        DataCell(Text("${m["id"]}")),
                        DataCell(Text(m["nombre"] ?? "")),
                        DataCell(Text("\$${m["precio"]}")),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () => _showModal(medicamento: m),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirmar = await showConfirmDeleteDialog(
                                    context,
                                    titulo: "Eliminar medicamento",
                                    mensaje:
                                        "¿Estás seguro de que deseas eliminar este medicamento? Esta acción no se puede deshacer.",
                                  );

                                  if (confirmar) {
                                    _delete(m["id"]);
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
