import 'package:frontend_veterinaria/services/api_service.dart';

class CitasService {
  static Future<List<dynamic>> listarCitas() async {
    return await ApiService.get("/citas/listar-citas");
  }

  static Future<bool> crearCita({
    required String fecha,
    required String hora,
    required int veterinarioId,
  }) async {
    await ApiService.post("/citas/crear-cita", {
      "fecha": fecha,
      "hora": hora,
      "veterinario_id": veterinarioId,
    });
    return true;
  }

  static Future<bool> actualizarCita({
    required int citaId,
    required String fecha,
    required String hora,
    required int veterinarioId,
    required String estado,
  }) async {
    await ApiService.put("/citas/actualizar-cita/$citaId", {
      "fecha": fecha,
      "hora": hora,
      "veterinario_id": veterinarioId,
      "estado": estado,
    });
    return true;
  }

  static Future<bool> eliminarCita(int id) async {
    await ApiService.delete("/citas/eliminar-cita/$id");
    return true;
  }
}
