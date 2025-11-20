import 'package:frontend_veterinaria/services/api_service.dart';

class VetCitasService {
  static Future<List<dynamic>> listarCitasVeterinario() async {
    return await ApiService.get("/citas/listar-citas-veterinario");
  }
static Future<bool> actualizarEstadoCita({
  required int citaId,
  required String estado,
}) async {
  await ApiService.put("/citas/actualizar-estado/$citaId", {
    "estado": estado,
  });

  return true;
}


}
