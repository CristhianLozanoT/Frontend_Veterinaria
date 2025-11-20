import 'package:frontend_veterinaria/services/api_service.dart';

class PetService {
  static Future<List<dynamic>> listarMascotas() async {
    final data = await ApiService.get("/mascotas/listar-mascotas");
    return data["data"]; 
  }

  static Future<Map<String, dynamic>> obtenerMascota(int id) async {
    return await ApiService.get("/mascotas/obtener-mascota/$id");
  }

  static Future<Map<String, dynamic>> crearMascota(
    Map<String, dynamic> data,
  ) async {
    return await ApiService.post("/mascotas/crear-mascota", data);
  }

  static Future<Map<String, dynamic>> editarMascota(
    int id,
    Map<String, dynamic> data,
  ) async {
    return await ApiService.put("/mascotas/actualizar-mascota/$id", data);
  }

  static Future eliminarMascota(int id) async {
    return await ApiService.delete("/mascotas/eliminar-mascota/$id");
  }

  static Future<List<dynamic>> listarMascotasPorCliente(int clienteId) async {
    final data = await ApiService.get("/mascotas/por-cliente/$clienteId");


    if (data is Map && data.containsKey("message")) {
      return [];
    }

    return data;
  }
}
