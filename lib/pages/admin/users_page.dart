import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/user_service.dart';
import 'package:frontend_veterinaria/widgets/dialog_confirm_delete.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final data = await UserService.getUsers();
      setState(() {
        users = data;
        loading = false;
      });
    } catch (e) {
      _showMessage("Error cargando usuarios: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _addUser(Map<String, dynamic> user) async {
    try {
      await UserService.createUser(user);
      _showMessage("Usuario creado correctamente");
      _loadUsers();
    } catch (e) {
      _showMessage("Error creando usuario: $e");
    }
  }

  Future<void> _editUser(int id, Map<String, dynamic> user) async {
    try {
      await UserService.updateUser(id, user);
      _showMessage("Usuario actualizado");
      _loadUsers();
    } catch (e) {
      _showMessage("Error actualizando usuario: $e");
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await UserService.deleteUser(id);
      _showMessage("Usuario eliminado");
      _loadUsers();
    } catch (e) {
      _showMessage("Error eliminando usuario: $e");
    }
  }

  void _showUserDialog({int? editIndex}) {
    final editing = editIndex != null;
    final user = editing ? users[editIndex] : null;

    final nombreCtrl = TextEditingController(text: user?['nombre']);
    final emailCtrl = TextEditingController(text: user?['email']);
    String rol = user?['rol'] ?? 'cliente';
    final passwordCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editing ? "Editar Usuario" : "Nuevo Usuario"),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _input("Nombre", nombreCtrl),
              _input("Email", emailCtrl),
              DropdownButtonFormField<String>(
                value: rol,
                decoration: const InputDecoration(
                  labelText: "Rol",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "administrador",
                    child: Text("Administrador"),
                  ),
                  DropdownMenuItem(
                    value: "veterinario",
                    child: Text("Veterinario"),
                  ),
                  DropdownMenuItem(
                    value: "secretaria",
                    child: Text("Secretaria"),
                  ),
                  DropdownMenuItem(value: "cliente", child: Text("Cliente")),
                ],
                onChanged: (v) => rol = v!,
              ),
              if (!editing) _input("Contraseña", passwordCtrl, password: true),
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
              if (nombreCtrl.text.isEmpty || emailCtrl.text.isEmpty) {
                _showMessage("Faltan datos");
                return;
              }

              final data = {
                "nombre": nombreCtrl.text,
                "email": emailCtrl.text,
                "rol": rol,
                if (!editing) "password": passwordCtrl.text,
              };

              editing ? _editUser(user["id"], data) : _addUser(data);

              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(editing ? "Guardar" : "Crear"),
          ),
        ],
      ),
    );
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    bool password = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: password,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Usuarios",
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
                    label: const Text("Nuevo usuario"),
                    onPressed: () => _showUserDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Nombre")),
                          DataColumn(label: Text("Rol")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Opciones")),
                        ],
                        rows: List.generate(users.length, (i) {
                          final u = users[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(u["nombre"])),
                              DataCell(Text(u["rol"])),
                              DataCell(Text(u["email"])),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.teal,
                                      ),
                                      onPressed: () =>
                                          _showUserDialog(editIndex: i),
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
                                              titulo: "Eliminar usuario",
                                              mensaje:
                                                  "¿Estás seguro de que deseas eliminar este usuario? Esta acción no se puede deshacer.",
                                            );

                                        if (confirmar) {
                                          _deleteUser(u["id"]);
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
                ],
              ),
            ),
    );
  }
}
