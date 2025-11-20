import 'package:frontend_veterinaria/services/api_service.dart';

class VetService {
  static Future<List<dynamic>> listarVeterinarios() async {
    final data = await ApiService.get("/listar-usuarios");

    return data.where((u) => u["rol"] == "veterinario").toList();
  }
}
