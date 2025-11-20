import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/raza_service.dart';
import 'package:frontend_veterinaria/widgets/dialog_confirm_delete.dart';

class RazasPage extends StatefulWidget {
  const RazasPage({super.key});

  @override
  State<RazasPage> createState() => _RazasPageState();
}

class _RazasPageState extends State<RazasPage> {
  List<dynamic> razas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarRazas();
  }

  Future<void> cargarRazas() async {
    setState(() => loading = true);
    try {
      razas = await RazaService.listarRazas();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
    setState(() => loading = false);
  }

  // =============================
  // FORM CREAR/EDITAR
  // =============================
  void _showRazaDialog({Map<String, dynamic>? raza}) {
    final editing = raza != null;

    String nombre = raza?["nombre"] ?? "";
    String descripcion = raza?["descripcion"] ?? "";

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text(
                editing ? "Editar Raza" : "Nueva Raza",
                style: GoogleFonts.inter(fontWeight: FontWeight.w700),
              ),
              content: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: nombre,
                      decoration: const InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => setInnerState(() => nombre = v),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: descripcion,
                      decoration: const InputDecoration(
                        labelText: "Descripción",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (v) => setInnerState(() => descripcion = v),
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
                    if (nombre.isEmpty || descripcion.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Completa los campos.")),
                      );
                      return;
                    }

                    try {
                      if (editing) {
                        await RazaService.actualizarRaza(
                          id: raza!["id"],
                          nombre: nombre,
                          descripcion: descripcion,
                        );
                      } else {
                        await RazaService.crearRaza(
                          nombre: nombre,
                          descripcion: descripcion,
                        );
                      }

                      Navigator.pop(context);
                      cargarRazas();
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
        );
      },
    );
  }

  // =============================
  // ELIMINAR
  // =============================
  void _deleteRaza(int id) async {
    try {
      await RazaService.eliminarRaza(id);
      cargarRazas();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // =============================
  // UI PRINCIPAL
  // =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Razas",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showRazaDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : razas.isEmpty
          ? const Center(child: Text("No hay razas registradas"))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nombre")),
                    DataColumn(label: Text("Descripción")),
                    DataColumn(label: Text("Acciones")),
                  ],
                  rows: razas.map((r) {
                    return DataRow(
                      cells: [
                        DataCell(Text("${r["id"]}")),
                        DataCell(Text(r["nombre"] ?? "")),
                        DataCell(Text(r["descripcion"] ?? "")),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () => _showRazaDialog(raza: r),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirmar = await showConfirmDeleteDialog(
                                    context,
                                    titulo: "Eliminar raza",
                                    mensaje:
                                        "¿Estás seguro de que deseas eliminar esta raza? Esta acción no se puede deshacer.",
                                  );

                                  if (confirmar) {
                                    _deleteRaza(r["id"]);
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
