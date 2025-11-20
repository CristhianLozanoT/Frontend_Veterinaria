import 'package:frontend_veterinaria/services/api_service.dart';

class UserService {
  static Future<List<dynamic>> getUsers() async {
    return await ApiService.get("/listar-usuarios");
  }

  static Future<bool> createUser(Map<String, dynamic> data) async {
    await ApiService.post("/crear-usuario", data);
    return true;
  }

  static Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    await ApiService.put("/actualizar-usuario/$id", data);
    return true;
  }

  static Future<bool> deleteUser(int id) async {
    await ApiService.delete("/eliminar-usuario/$id");
    return true;
  }
}
