import 'package:frontend_veterinaria/services/api_service.dart';

class ClienteService {
  static Future<List<dynamic>> listarClientes() async {
    final data = await ApiService.get("/clientes/listar-clientes");

    return data;   
  }
}
