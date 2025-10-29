import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_manager/core/network/auth/IApiclient.dart';

class ApiClientfrombackend extends IApiClient {
  final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? _cachedToken;

  ApiClientfrombackend(String baseUrl)
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: 10000, // 10 giây
          receiveTimeout: 10000, // 10 giây
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _cachedToken ??= await storage.read(key: 'token');
          print(
            'Interceptor - Current token: $_cachedToken',
          ); 
          if (_cachedToken != null) {
            options.headers['Authorization'] = 'Bearer $_cachedToken';
            print(
              'Added Authorization header: ${options.headers['Authorization']}',
            ); 
          } else {
            print('No token available for request'); 
          }
          return handler.next(options);
        },
        onError: (e, handler) => handler.next(e),
      ),
    );
  }

  @override
  Future<dynamic> get(String path) async {
    try {
      print('Making GET request to: $path');
      print('Current token: $_cachedToken');
      final response = await dio.get(path);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Error in GET request: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      print('Making POST request to: $path');
      print('Request body: $body');
      final response = await dio.post(path, data: body);
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } catch (e) {
      print('Error in POST request: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> put(String path, Map<String, dynamic> body) async =>
      (await dio.put(path, data: body)).data;

  @override
  Future<void> delete(String path) async => await dio.delete(path);

  @override
  Future<void> setToken(String token) async {
    if (token.trim().isEmpty) {
      print('ApiClient.setToken called with empty token; ignoring');
      return;
    }
    _cachedToken = token;
    await storage.write(key: 'token', value: token);
  }

  @override
  Future<void> clearToken() async {
    _cachedToken = null;
    await storage.delete(key: 'token');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await storage.read(key: 'token');
    return token != null;
  }
}
