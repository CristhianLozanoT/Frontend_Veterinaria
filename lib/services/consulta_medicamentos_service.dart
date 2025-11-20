import 'package:frontend_veterinaria/services/api_service.dart';

class ConsultaMedicamentosService {
  static Future<List<dynamic>> listarMedicamentos(int consultaId) async {
    return await ApiService.get("/consulta-medicamentos/listar/$consultaId");
  }

  static Future<dynamic> agregar({
    required int consultaId,
    required int medicamentoId,
    required int cantidad,
  }) async {
    return await ApiService.post("/consulta-medicamentos/agregar", {
      "consulta_id": consultaId,
      "medicamento_id": medicamentoId,
      "cantidad": cantidad,
    });
  }

  static Future<dynamic> actualizar({
    required int consultaId,
    required int medicamentoId,
    required int cantidad,
  }) async {
    return await ApiService.put("/consulta-medicamentos/actualizar", {
      "consulta_id": consultaId,
      "medicamento_id": medicamentoId,
      "cantidad": cantidad,
    });
  }

  static Future<dynamic> eliminar(int consultaId, int medicamentoId) async {
    return await ApiService.delete(
      "/consulta-medicamentos/eliminar/$consultaId/$medicamentoId",
    );
  }
}
