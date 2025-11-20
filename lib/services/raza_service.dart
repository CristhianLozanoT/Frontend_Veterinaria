import 'package:frontend_veterinaria/services/api_service.dart';

class RazaService {
  static Future<List<dynamic>> listarRazas() async {
    final data = await ApiService.get("/razas/listar-razas");
    return data;
  }

  static Future<Map<String, dynamic>> obtenerRaza(int id) async {
    final data = await ApiService.get("/razas/obtener-raza/$id");
    return data;
  }

  static Future<bool> crearRaza({
    required String nombre,
    required String descripcion,
  }) async {
    await ApiService.post("/razas/crear-raza", {
      "nombre": nombre,
      "descripcion": descripcion,
    });
    return true;
  }

  static Future<bool> actualizarRaza({
    required int id,
    required String nombre,
    required String descripcion,
  }) async {
    await ApiService.put("/razas/actualizar-raza/$id", {
      "nombre": nombre,
      "descripcion": descripcion,
    });
    return true;
  }

  static Future<bool> eliminarRaza(int id) async {
    await ApiService.delete("/razas/eliminar-raza/$id");
    return true;
  }
}
