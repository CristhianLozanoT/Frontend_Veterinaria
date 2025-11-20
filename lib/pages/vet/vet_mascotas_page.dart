import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/pet_service.dart';
import '../../services/cliente_service.dart';
import '../../services/raza_service.dart';
import 'package:frontend_veterinaria/widgets/dialog_confirm_delete.dart';

class VetMascotasPage extends StatefulWidget {
  const VetMascotasPage({super.key});

  @override
  State<VetMascotasPage> createState() => _VetMascotasPageState();
}

class _VetMascotasPageState extends State<VetMascotasPage> {
  List<dynamic> mascotas = [];
  List<dynamic> clientes = [];
  List<dynamic> razas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      mascotas = await PetService.listarMascotas();
      clientes = await ClienteService.listarClientes();
      razas = await RazaService.listarRazas();
    } catch (e) {
      _msg("Error cargando datos: $e");
    }

    setState(() => loading = false);
  }

  void _showPetDialog({int? editIndex}) {
    final editing = editIndex != null;
    final pet = editing ? mascotas[editIndex!] : null;

    final nombreCtrl = TextEditingController(text: pet?["nombre"]);
    final edadCtrl = TextEditingController(text: pet?["edad"]?.toString());
    final pesoCtrl = TextEditingController(text: pet?["peso"]?.toString());

    int? clienteId = pet?["cliente"]?["id"];
    int? razaId = pet?["raza"]?["id"];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
              editing ? "Editar Mascota" : "Nueva Mascota",
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _input("Nombre", nombreCtrl),
                  _input("Edad", edadCtrl),
                  _input("Peso (kg)", pesoCtrl),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<int>(
                    value: razaId,
                    decoration: const InputDecoration(
                      labelText: "Raza",
                      border: OutlineInputBorder(),
                    ),
                    items: razas
                        .map<DropdownMenuItem<int>>(
                          (r) => DropdownMenuItem(
                            value: r["id"],
                            child: Text(r["nombre"]),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setStateDialog(() => razaId = v),
                  ),

                  const SizedBox(height: 12),

                  IgnorePointer(
                    ignoring: editing,
                    child: Opacity(
                      opacity: editing ? 0.5 : 1,
                      child: DropdownButtonFormField<int>(
                        value: clienteId,
                        decoration: const InputDecoration(
                          labelText: "Dueño (Cliente)",
                          border: OutlineInputBorder(),
                        ),
                        items: clientes
                            .map<DropdownMenuItem<int>>(
                              (c) => DropdownMenuItem(
                                value: c["id"],
                                child: Text(c["nombre"]),
                              ),
                            )
                            .toList(),
                        onChanged: editing
                            ? null
                            : (v) => setStateDialog(() => clienteId = v),
                      ),
                    ),
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
                onPressed: () async {
                  if (nombreCtrl.text.isEmpty ||
                      edadCtrl.text.isEmpty ||
                      pesoCtrl.text.isEmpty ||
                      razaId == null ||
                      (!editing && clienteId == null)) {
                    _msg("Completa todos los campos");
                    return;
                  }

                  final dataCrear = {
                    "cliente_id": clienteId,
                    "raza_id": razaId,
                    "nombre": nombreCtrl.text,
                    "edad": int.parse(edadCtrl.text),
                    "peso": double.parse(pesoCtrl.text),
                  };

                  final dataEditar = {
                    "raza_id": razaId,
                    "nombre": nombreCtrl.text,
                    "edad": int.parse(edadCtrl.text),
                    "peso": double.parse(pesoCtrl.text),
                  };

                  try {
                    if (editing) {
                      await PetService.editarMascota(pet["id"], dataEditar);
                    } else {
                      await PetService.crearMascota(dataCrear);
                    }

                    Navigator.pop(context);
                    cargarDatos();
                    _msg(
                      editing ? "Mascota actualizada" : "Mascota registrada",
                    );
                  } catch (e) {
                    _msg("Error: $e");
                  }
                },
                child: Text(editing ? "Guardar" : "Crear"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _deletePet(int id) async {
    final confirmar = await showConfirmDeleteDialog(
      context,
      titulo: "Eliminar mascota",
      mensaje: "¿Estás seguro? Esta acción no se puede deshacer.",
    );

    if (!confirmar) return;

    try {
      await PetService.eliminarMascota(id);
      cargarDatos();
      _msg("Mascota eliminada");
    } catch (e) {
      _msg("Error eliminando mascota: $e");
    }
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _msg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showPetDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Nombre")),
                          DataColumn(label: Text("Edad")),
                          DataColumn(label: Text("Peso")),
                          DataColumn(label: Text("Raza")),
                          DataColumn(label: Text("Dueño")),
                          DataColumn(label: Text("Acciones")),
                        ],
                        rows: List.generate(mascotas.length, (i) {
                          final m = mascotas[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(m["id"].toString())),
                              DataCell(Text(m["nombre"])),
                              DataCell(Text("${m["edad"]} años")),
                              DataCell(Text("${m["peso"]} kg")),
                              DataCell(Text(m["raza"]?["nombre"] ?? "—")),
                              DataCell(
                                Text(m["cliente"]?["nombre"] ?? "Sin dueño"),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.teal,
                                      ),
                                      onPressed: () =>
                                          _showPetDialog(editIndex: i),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deletePet(m["id"]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
