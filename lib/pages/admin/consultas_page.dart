import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend_veterinaria/widgets/dialog_confirm_delete.dart';

import '../../services/consultas_service.dart';
import '../../services/cliente_service.dart';
import '../../services/vet_service.dart';
import '../../services/citas_service.dart';
import '../../services/pet_service.dart';

class ConsultasPage extends StatefulWidget {
  const ConsultasPage({super.key});

  @override
  State<ConsultasPage> createState() => _ConsultasPageState();
}

class _ConsultasPageState extends State<ConsultasPage> {
  List<dynamic> consultas = [];
  List<dynamic> clientes = [];
  List<dynamic> veterinarios = [];
  List<dynamic> citas = [];

  List<dynamic> todasMascotas = [];

  List<dynamic> mascotasCliente = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarTodo();
  }

  Future<void> cargarTodo() async {
    setState(() => loading = true);

    try {
      consultas = await ConsultasService.listarConsultas();
      clientes = await ClienteService.listarClientes();
      veterinarios = await VetService.listarVeterinarios();
      citas = await CitasService.listarCitas();
      todasMascotas = await PetService.listarMascotas();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  String _nombreCliente(int? id) {
    if (id == null) return "";
    final cli = clientes.firstWhere((c) => c["id"] == id, orElse: () => null);
    return cli?["nombre"] ?? "ID $id";
  }

  String _nombreVeterinario(int? id) {
    if (id == null) return "";
    final vet = veterinarios.firstWhere(
      (v) => v["id"] == id,
      orElse: () => null,
    );
    return vet?["nombre"] ?? "ID $id";
  }

  String _textoMascota(int? id) {
    if (id == null) return "";
    final m = todasMascotas.firstWhere(
      (x) => x["id"] == id,
      orElse: () => null,
    );
    if (m == null) return "ID $id";
    return "${m["id"]} - ${m["nombre"]}";
  }

  // -------------------------------------------------------
  //  CREAR / EDITAR CONSULTA
  // -------------------------------------------------------

  void _showConsultaDialog({Map<String, dynamic>? consulta}) {
    final editing = consulta != null;

    int? clienteId = consulta?["cliente_id"];
    int? mascotaId = consulta?["mascota_id"];
    int? citaId = consulta?["cita_id"];
    int? veterinarioId = consulta?["veterinario_id"];

    String diagnostico = consulta?["diagnostico"] ?? "";
    String total = consulta?["total"]?.toString() ?? "";

    // Cargar mascotas del cliente si está editando
    if (editing && clienteId != null) {
      PetService.listarMascotasPorCliente(clienteId).then((lista) {
        setState(() => mascotasCliente = lista);
      });
    }

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: Text(editing ? "Editar Consulta" : "Nueva Consulta"),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ------------------- CLIENTE -------------------
                    DropdownButtonFormField<int>(
                      value: clienteId,
                      decoration: const InputDecoration(
                        labelText: "Cliente",
                        border: OutlineInputBorder(),
                      ),
                      items: clientes
                          .map(
                            (c) => DropdownMenuItem<int>(
                              value: c["id"],
                              child: Text(c["nombre"]),
                            ),
                          )
                          .toList(),
                      onChanged: (v) async {
                        if (v == null) return;

                        setInnerState(() {
                          clienteId = v;
                          mascotaId = null;
                          mascotasCliente = [];
                        });

                        final lista = await PetService.listarMascotasPorCliente(
                          v,
                        );

                        setInnerState(() {
                          mascotasCliente = lista;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // ------------------- MASCOTA -------------------
                    DropdownButtonFormField<int>(
                      value: mascotaId,
                      decoration: const InputDecoration(
                        labelText: "Mascota",
                        border: OutlineInputBorder(),
                      ),
                      items: mascotasCliente
                          .map(
                            (m) => DropdownMenuItem<int>(
                              value: m["id"],
                             
                              child: Text("${m["id"]} - ${m["nombre"]}"),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setInnerState(() => mascotaId = v);
                      },
                    ),
                    const SizedBox(height: 12),

                    // ------------------- CITA (solo crear) ----------
                    if (!editing)
                      DropdownButtonFormField<int>(
                        value: citaId,
                        decoration: const InputDecoration(
                          labelText: "Cita disponible",
                          border: OutlineInputBorder(),
                        ),
                        items: citas
                            .where(
                              (c) => !consultas
                                  .map((co) => co["cita_id"])
                                  .contains(c["id"]),
                            )
                            .map(
                              (c) => DropdownMenuItem<int>(
                                value: c["id"],
                                child: Text("${c["fecha"]} — ${c["hora"]}"),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          final citaSel = citas.firstWhere((c) => c["id"] == v);

                          setInnerState(() {
                            citaId = v;
                            veterinarioId = citaSel["veterinario"]["id"];
                          });
                        },
                      ),
                    if (!editing) const SizedBox(height: 12),

                    // ------------------- VETERINARIO (solo lectura) --
                    TextFormField(
                      enabled: false,
                      initialValue: veterinarioId != null
                          ? _nombreVeterinario(veterinarioId)
                          : "",
                      decoration: const InputDecoration(
                        labelText: "Veterinario",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ------------------- DIAGNÓSTICO ----------------
                    TextFormField(
                      initialValue: diagnostico,
                      decoration: const InputDecoration(
                        labelText: "Diagnóstico",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (v) => setInnerState(() => diagnostico = v),
                    ),
                    const SizedBox(height: 12),

                    // ------------------- TOTAL --------------------
                    TextFormField(
                      initialValue: total,
                      decoration: const InputDecoration(
                        labelText: "Total",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setInnerState(() => total = v),
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
                    if (clienteId == null ||
                        mascotaId == null ||
                        diagnostico.isEmpty ||
                        total.isEmpty ||
                        (!editing && citaId == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Completa todos los campos requeridos.",
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      if (editing) {
                        await ConsultasService.actualizarConsulta(
                          consultaId: consulta!["id"],
                          clienteId: clienteId!,
                          mascotaId: mascotaId!,
                          veterinarioId: veterinarioId!,
                          diagnostico: diagnostico,
                          total: double.tryParse(total) ?? 0,
                        );
                      } else {
                        await ConsultasService.crearConsulta(
                          citaId: citaId!,
                          clienteId: clienteId!,
                          mascotaId: mascotaId!,
                          veterinarioId: veterinarioId!,
                          diagnostico: diagnostico,
                          total: double.tryParse(total) ?? 0,
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
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteConsulta(int id) async {
    try {
      await ConsultasService.eliminarConsulta(id);
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
          "Consultas",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.teal[700],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _showConsultaDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : consultas.isEmpty
          ? const Center(child: Text("No hay consultas registradas"))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Mascota (ID - Nombre)")),
                    DataColumn(label: Text("Cliente")),
                    DataColumn(label: Text("Veterinario")),
                    DataColumn(label: Text("Diagnóstico")),
                    DataColumn(label: Text("Total")),
                    DataColumn(label: Text("Acciones")),
                  ],
                  rows: consultas.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text(_textoMascota(c["mascota_id"]))),
                        DataCell(Text(_nombreCliente(c["cliente_id"]))),
                        DataCell(Text(_nombreVeterinario(c["veterinario_id"]))),
                        DataCell(Text(c["diagnostico"] ?? "")),
                        DataCell(Text("\$${c["total"] ?? 0}")),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                                onPressed: () =>
                                    _showConsultaDialog(consulta: c),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirmar = await showConfirmDeleteDialog(
                                    context,
                                    titulo: "Eliminar consulta",
                                    mensaje:
                                        "¿Estás seguro de que deseas eliminar esta consulta? Esta acción no se puede deshacer.",
                                  );

                                  if (confirmar) {
                                    _deleteConsulta(c["id"]);
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
