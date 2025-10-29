import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:project_manager/core/network/customer/IApiClient.dart';

class ApiFromBackend implements IApiClient {
  final String baseUrl;

  ApiFromBackend(this.baseUrl) {
    HttpOverrides.global = _MyHttpOverrides();
  }

  @override
  Future<dynamic> get(String path) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('GET $path failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch: $e');
    }
  }

  @override
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('POST $path failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post: $e');
    }
  }

  @override
  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 204) {
        // Trả về null cho response 204 No Content
        return null;
      } else {
        throw Exception('PUT $path failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to put: $e');
    }
  }

  @override
  Future<void> delete(String path) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'DELETE $path failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to delete: $e');
    }
  }
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
