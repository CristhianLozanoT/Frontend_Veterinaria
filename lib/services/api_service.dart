import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  static String? _token;
  static Map<String, dynamic>? _currentUser;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");

    final userJson = prefs.getString("user");
    if (userJson != null) {
      _currentUser = jsonDecode(userJson);
    }
  }

  static String? get token => _token;
  static Map<String, dynamic>? get user => _currentUser;

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      _token = data["access_token"];
      _currentUser = data["usuario"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", _token!);
      await prefs.setString("user", jsonEncode(_currentUser));

      return true;
    }

    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user");

    _token = null;
    _currentUser = null;
  }

  static Map<String, String> _headers() {
    if (_token == null) {
      throw Exception("No hay token. Inicia sesión.");
    }

    return {
      "Authorization": "Bearer $_token",
      "Content-Type": "application/json",
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final res = await http.get(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Error GET: ${res.body}");
  }

  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final res = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }

    throw Exception("Error POST: ${res.body}");
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final res = await http.put(
      url,
      headers: _headers(),
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Error PUT: ${res.body}");
  }

  static Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final res = await http.delete(url, headers: _headers());

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    throw Exception("Error DELETE: ${res.body}");
  }
}
