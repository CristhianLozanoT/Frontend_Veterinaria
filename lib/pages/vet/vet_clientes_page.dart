import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/clientes_service.dart';
import '../../widgets/dialog_confirm_delete.dart';

class VetClientesPage extends StatefulWidget {
  const VetClientesPage({super.key});

  @override
  State<VetClientesPage> createState() => _VetClientesPageState();
}

class _VetClientesPageState extends State<VetClientesPage> {
  List<dynamic> clientes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  
  
  
  Future<void> _loadClientes() async {
    try {
      final data = await ClientesService.listarClientes();
      setState(() {
        clientes = data;
        loading = false;
      });
    } catch (e) {
      _showMessage("Error cargando clientes: $e");
      setState(() => loading = false);
    }
  }

  
  
  
  Future<void> _addCliente(Map<String, dynamic> cliente) async {
    try {
      await ClientesService.crearCliente(
        cliente["nombre"],
        cliente["telefono"],
        cliente["direccion"],
      );

      _showMessage("Cliente creado correctamente");
      _loadClientes();
    } catch (e) {
      _showMessage("Error creando cliente: $e");
    }
  }

  
  
  
  Future<void> _editCliente(int id, Map<String, dynamic> cliente) async {
    try {
      await ClientesService.actualizarCliente(
        id,
        cliente["nombre"],
        cliente["telefono"],
        cliente["direccion"],
      );

      _showMessage("Cliente actualizado");
      _loadClientes();
    } catch (e) {
      _showMessage("Error actualizando cliente: $e");
    }
  }

  
  
  
  Future<void> _deleteCliente(int id) async {
    try {
      await ClientesService.eliminarCliente(id);
      _showMessage("Cliente eliminado");
      _loadClientes();
    } catch (e) {
      _showMessage("Error eliminando cliente: $e");
    }
  }

  
  
  
  void _showClienteDialog({int? editIndex}) {
    final editing = editIndex != null;
    final c = editing ? clientes[editIndex] : null;

    final nombreCtrl = TextEditingController(text: c?["nombre"]);
    final telefonoCtrl = TextEditingController(text: c?["telefono"]);
    final direccionCtrl = TextEditingController(text: c?["direccion"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editing ? "Editar Cliente" : "Nuevo Cliente"),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _input("Nombre", nombreCtrl),
              _input("Teléfono", telefonoCtrl),
              _input("Dirección", direccionCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.isEmpty ||
                  telefonoCtrl.text.isEmpty ||
                  direccionCtrl.text.isEmpty) {
                _showMessage("Todos los campos son obligatorios");
                return;
              }

              final data = {
                "nombre": nombreCtrl.text,
                "telefono": telefonoCtrl.text,
                "direccion": direccionCtrl.text,
              };

              editing
                  ? _editCliente(c["id"], data)
                  : _addCliente(data);

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(editing ? "Guardar" : "Crear"),
          ),
        ],
      ),
    );
  }

  
  
  
  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Clientes",
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
              child: Column(
                children: [
                  
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Nuevo cliente"),
                    onPressed: () => _showClienteDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),

                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Nombre")),
                          DataColumn(label: Text("Teléfono")),
                          DataColumn(label: Text("Dirección")),
                          DataColumn(label: Text("Opciones")),
                        ],
                        rows: List.generate(clientes.length, (i) {
                          final c = clientes[i];

                          return DataRow(
                            cells: [
                              DataCell(Text("${c["id"]}")),
                              DataCell(Text(c["nombre"])),
                              DataCell(Text(c["telefono"])),
                              DataCell(Text(c["direccion"])),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.teal),
                                      onPressed: () =>
                                          _showClienteDialog(editIndex: i),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final confirmar =
                                            await showConfirmDeleteDialog(
                                          context,
                                          titulo: "Eliminar cliente",
                                          mensaje:
                                              "¿Seguro que deseas eliminar este cliente?",
                                        );

                                        if (confirmar) {
                                          _deleteCliente(c["id"]);
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
                  )
                ],
              ),
            ),
    );
  }
}
