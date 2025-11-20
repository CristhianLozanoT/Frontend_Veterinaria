import 'package:frontend_veterinaria/services/api_service.dart';

class ConsultasService {
  static Future<List<dynamic>> listarConsultas() async {
    return await ApiService.get("/consultas/listar-consultas");
  }

  static Future<bool> crearConsulta({
    required int citaId,
    required int clienteId,
    required int mascotaId,
    required int veterinarioId,
    required String diagnostico,
    required double total,
  }) async {
    await ApiService.post("/consultas/crear-consulta", {
      "cita_id": citaId,
      "cliente_id": clienteId,
      "mascota_id": mascotaId,
      "veterinario_id": veterinarioId,
      "diagnostico": diagnostico,
      "total": total,
    });

    return true;
  }

  static Future<bool> actualizarConsulta({
    required int consultaId,
    required int clienteId,
    required int mascotaId,
    required int veterinarioId,
    required String diagnostico,
    required double total,
  }) async {
    await ApiService.put("/consultas/actualizar-consulta/$consultaId", {
      "cliente_id": clienteId,
      "mascota_id": mascotaId,
      "veterinario_id": veterinarioId,
      "diagnostico": diagnostico,
      "total": total,
    });

    return true;
  }

  static Future<bool> eliminarConsulta(int id) async {
    await ApiService.delete("/consultas/eliminar-consulta/$id");
    return true;
  }
}
