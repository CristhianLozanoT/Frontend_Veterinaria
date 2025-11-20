import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/consultas_service.dart';
import '../../services/pet_service.dart';
import '../../services/cliente_service.dart';
import 'vet_consulta_medicamentos_page.dart';

class VetConsultasPage extends StatefulWidget {
  const VetConsultasPage({super.key});

  @override
  State<VetConsultasPage> createState() => _VetConsultasPageState();
}

class _VetConsultasPageState extends State<VetConsultasPage> {
  bool loading = true;

  List<dynamic> consultas = [];
  List<dynamic> clientes = [];
  List<dynamic> mascotas = [];

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
      mascotas = await PetService.listarMascotas();
    } catch (e) {
      _msg("Error cargando datos: $e");
    }

    setState(() => loading = false);
  }

  String _nombreMascota(int id) {
    final m = mascotas.firstWhere((x) => x["id"] == id, orElse: () => null);
    return m != null ? "${m["id"]} - ${m["nombre"]}" : "ID $id";
  }

  String _nombreCliente(int id) {
    final c = clientes.firstWhere((x) => x["id"] == id, orElse: () => null);
    return c != null ? c["nombre"] : "ID $id";
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _showConsultaDialog({Map<String, dynamic>? consulta}) {
    final editing = consulta != null;

    int? clienteId = consulta?["cliente_id"];
    int? mascotaId = consulta?["mascota_id"];
    String diagnostico = consulta?["diagnostico"] ?? "";
    String total = consulta?["total"]?.toString() ?? "";

    List<dynamic> mascotasCliente = [];

    if (editing && clienteId != null) {
      mascotasCliente = mascotas
          .where((m) => m["cliente_id"] == clienteId)
          .toList();
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setInnerState) {
          return AlertDialog(
            title: Text(
              editing ? "Editar Consulta" : "Nueva Consulta",
              style: GoogleFonts.inter(fontWeight: FontWeight.w700),
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  editing
                      ? TextFormField(
                          enabled: false,
                          initialValue: _nombreCliente(clienteId!),
                          decoration: const InputDecoration(
                            labelText: "Cliente",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: "Cliente",
                            border: OutlineInputBorder(),
                          ),
                          value: clienteId,
                          items: clientes
                              .map<DropdownMenuItem<int>>(
                                (c) => DropdownMenuItem<int>(
                                  value: c["id"] as int,
                                  child: Text(c["nombre"]),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setInnerState(() {
                              clienteId = v;
                              mascotaId = null;
                              mascotasCliente = mascotas
                                  .where((m) => m["cliente_id"] == clienteId)
                                  .toList();
                            });
                          },
                        ),

                  const SizedBox(height: 12),

                  editing
                      ? TextFormField(
                          enabled: false,
                          initialValue: _nombreMascota(mascotaId!),
                          decoration: const InputDecoration(
                            labelText: "Mascota",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: "Mascota",
                            border: OutlineInputBorder(),
                          ),
                          value: mascotaId,
                          items: mascotasCliente
                              .map<DropdownMenuItem<int>>(
                                (m) => DropdownMenuItem<int>(
                                  value: m["id"] as int,
                                  child: Text("${m["id"]} - ${m["nombre"]}"),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setInnerState(() => mascotaId = v),
                        ),

                  const SizedBox(height: 12),

                  TextFormField(
                    initialValue: diagnostico,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Diagnóstico",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setInnerState(() => diagnostico = v),
                  ),

                  const SizedBox(height: 12),

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
                      total.isEmpty) {
                    _msg("Completa todos los campos");
                    return;
                  }

                  try {
                    if (editing) {
                      await ConsultasService.actualizarConsulta(
                        consultaId: consulta!["id"],
                        clienteId: clienteId!,
                        mascotaId: mascotaId!,
                        veterinarioId: consulta["veterinario_id"],
                        diagnostico: diagnostico,
                        total: double.tryParse(total) ?? 0,
                      );
                    } else {
                      await ConsultasService.crearConsulta(
                        citaId: 0,
                        clienteId: clienteId!,
                        mascotaId: mascotaId!,
                        veterinarioId: 0,
                        diagnostico: diagnostico,
                        total: double.tryParse(total) ?? 0,
                      );
                    }

                    Navigator.pop(context);
                    cargarTodo();
                  } catch (e) {
                    _msg("Error: $e");
                  }
                },
              ),
            ],
          );
        },
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
          "Mis Consultas",
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
          ? const Center(child: Text("No tienes consultas registradas"))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Mascota")),
                    DataColumn(label: Text("Cliente")),
                    DataColumn(label: Text("Diagnóstico")),
                    DataColumn(label: Text("Total")),
                    DataColumn(label: Text("Medicamentos")),
                    DataColumn(label: Text("Acciones")),
                  ],
                  rows: consultas.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(Text(_nombreMascota(c["mascota_id"]))),
                        DataCell(Text(_nombreCliente(c["cliente_id"]))),
                        DataCell(Text(c["diagnostico"] ?? "")),
                        DataCell(Text("\$${c["total"]}")),

                        DataCell(
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade300,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VetConsultaMedicamentosPage(
                                    consultaId: c["id"],
                                  ),
                                ),
                              );
                            },
                            child: const Text("Ver"),
                          ),
                        ),

                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.teal),
                            onPressed: () => _showConsultaDialog(consulta: c),
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
