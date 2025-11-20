import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClientesService {
  static const String baseUrl = "http://localhost:8000/api"; 

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<List<dynamic>> listarClientes() async {
    final token = await _getToken();
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("$baseUrl/clientes/listar-clientes");

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Error listando clientes: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> crearCliente(
      String nombre, String telefono, String direccion) async {

    final token = await _getToken();
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("$baseUrl/clientes/crear-cliente");

    final body = {
      "nombre": nombre,
      "telefono": telefono,
      "direccion": direccion,
    };

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception("Error creando cliente: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> actualizarCliente(
      int id, String? nombre, String? telefono, String? direccion) async {

    final token = await _getToken();
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("$baseUrl/clientes/actualizar-cliente/$id");

    final body = {
      "nombre": nombre,
      "telefono": telefono,
      "direccion": direccion,
    };

    final res = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception("Error actualizando cliente: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> eliminarCliente(int id) async {
    final token = await _getToken();
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("$baseUrl/clientes/eliminar-cliente/$id");

    final res = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Error eliminando cliente: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> obtenerCliente(int id) async {
    final token = await _getToken();
    if (token == null) throw Exception("Token no encontrado");

    final url = Uri.parse("$baseUrl/clientes/obtener-cliente/$id");

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Error obteniendo cliente: ${res.body}");
    }

    return jsonDecode(res.body);
  }
}
