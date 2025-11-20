import 'package:frontend_veterinaria/services/api_service.dart';

class MedicamentosService {
  static Future<List<dynamic>> listarMedicamentos() async {
    final data = await ApiService.get("/medicamentos/listar-medicamentos");
    return data;
  }

  static Future<Map<String, dynamic>> obtenerMedicamento(int id) async {
    return await ApiService.get("/medicamentos/obtener-medicamento/$id");
  }

  static Future<Map<String, dynamic>> crearMedicamento({
    required String nombre,
    required double precio,
  }) async {
    return await ApiService.post("/medicamentos/crear-medicamento", {
      "nombre": nombre,
      "precio": precio,
    });
  }

  static Future<Map<String, dynamic>> actualizarMedicamento({
    required int id,
    required String nombre,
    required double precio,
  }) async {
    return await ApiService.put("/medicamentos/actualizar-medicamento/$id", {
      "nombre": nombre,
      "precio": precio,
    });
  }

  static Future eliminarMedicamento(int id) async {
    return await ApiService.delete("/medicamentos/eliminar-medicamento/$id");
  }
}
