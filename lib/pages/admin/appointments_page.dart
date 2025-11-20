import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/citas_service.dart';
import '../../services/vet_service.dart';
import 'package:frontend_veterinaria/widgets/dialog_confirm_delete.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<dynamic> citas = [];
  List<dynamic> veterinarios = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    setState(() => loading = true);

    try {
      citas = await CitasService.listarCitas();
      veterinarios = await VetService.listarVeterinarios();

      if (citas.isNotEmpty && citas.first["message"] != null) {
        citas = [];
      }

      citas = citas
          .where(
            (c) =>
                c.containsKey("fecha") &&
                c.containsKey("hora") &&
                c.containsKey("veterinario") &&
                c["veterinario"] != null &&
                c.containsKey("estado"),
          )
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<String?> pickFecha(BuildContext context, String? valorActual) async {
    DateTime initial = DateTime.now();

    if (valorActual != null && valorActual.isNotEmpty) {
      initial = DateTime.tryParse(valorActual) ?? DateTime.now();
    }

    final fecha = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (fecha == null) return null;

    return "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";
  }

  Future<String?> pickHora(BuildContext context, String? valorActual) async {
    TimeOfDay initial = TimeOfDay.now();

    if (valorActual != null && valorActual.contains(":")) {
      final parts = valorActual.split(":");
      initial = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    final h = await showTimePicker(context: context, initialTime: initial);

    if (h == null) return null;

    return "${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}";
  }

  void _showCitaDialog({Map<String, dynamic>? cita}) {
    final editing = cita != null;

    String fecha = cita?["fecha"]?.toString() ?? "";
    String hora = cita?["hora"]?.toString() ?? "";
    int? veterinarioId = cita != null ? cita["veterinario_id"] : null;
    String estado =
        {
          "pendiente": "PROGRAMADA",
          "completada": "REALIZADA",
          "cancelada": "CANCELADA",
        }[cita?["estado"]] ??
        "PROGRAMADA";

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text(editing ? "Editar Cita" : "Nueva Cita"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FECHA
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: fecha),
                    decoration: const InputDecoration(
                      labelText: "Fecha",
                      border: OutlineInputBorder(),
                    ),

                    onTap: () async {
                      final f = await pickFecha(context, fecha);
                      if (f != null) {
                        setInnerState(() => fecha = f);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // HORA
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(text: hora),
                    decoration: const InputDecoration(
                      labelText: "Hora",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final h = await pickHora(context, hora);
                      if (h != null) {
                        setInnerState(() => hora = h);
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // VETERINARIO
                  DropdownButtonFormField<int>(
                    value: veterinarioId,
                    decoration: const InputDecoration(
                      labelText: "Veterinario",
                      border: OutlineInputBorder(),
                    ),
                    items: veterinarios
                        .map<DropdownMenuItem<int>>(
                          (v) => DropdownMenuItem(
                            value: v["id"],
                            child: Text(v["nombre"]),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setInnerState(() {
                        veterinarioId = v;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  if (editing)
                    DropdownButtonFormField<String>(
                      value: estado,
                      decoration: const InputDecoration(
                        labelText: "Estado",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "PROGRAMADA",
                          child: Text("Pendiente"),
                        ),
                        DropdownMenuItem(
                          value: "REALIZADA",
                          child: Text("Completada"),
                        ),
                        DropdownMenuItem(
                          value: "CANCELADA",
                          child: Text("Cancelada"),
                        ),
                      ],
                      onChanged: (v) {
                        setInnerState(() => estado = v!);
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () async {
                    if (veterinarioId == null ||
                        fecha.isEmpty ||
                        hora.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Completa todos los campos"),
                        ),
                      );
                      return;
                    }

                    try {
                      if (editing) {
                        await CitasService.actualizarCita(
                          citaId: cita!["id"],
                          fecha: fecha,
                          hora: hora,
                          veterinarioId: veterinarioId!,
                          estado: {
                            "PROGRAMADA": "pendiente",
                            "REALIZADA": "completada",
                            "CANCELADA": "cancelada",
                          }[estado]!,
                        );
                      } else {
                        await CitasService.crearCita(
                          fecha: fecha,
                          hora: hora,
                          veterinarioId: veterinarioId!,
                        );
                      }

                      Navigator.pop(context);
                      cargarTodo();
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: Text(editing ? "Guardar" : "Crear"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteCita(int id) async {
    try {
      await CitasService.eliminarCita(id);
      cargarTodo();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Citas",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showCitaDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : citas.isEmpty
          ? const Center(child: Text("No hay citas registradas"))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Fecha")),
                    DataColumn(label: Text("Hora")),
                    DataColumn(label: Text("Veterinario")),
                    DataColumn(label: Text("Estado")),
                    DataColumn(label: Text("Acciones")),
                  ],
                  rows: List.generate(citas.length, (i) {
                    final c = citas[i];
                    return DataRow(
                      cells: [
                        DataCell(Text((c["fecha"] ?? "").toString())),
                        DataCell(Text((c["hora"] ?? "").toString())),
                        DataCell(
                          Text(
                            c["veterinario"]?["nombre"] ?? "Sin veterinario",
                          ),
                        ),

                        DataCell(Text((c["estado"] ?? "").toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () => _showCitaDialog(cita: c),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirmar = await showConfirmDeleteDialog(
                                    context,
                                    titulo: "Eliminar Cita",
                                    mensaje:
                                        "¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.",
                                  );

                                  if (confirmar) {
                                    _deleteCita(c["id"]);
                                  }
                                },
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
    );
  }
}
