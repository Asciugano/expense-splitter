import 'dart:convert';

import 'package:expense_splitter/core/exception/exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  final FlutterSecureStorage _storage;

  ApiClient({
    required this.baseUrl,
    http.Client? client,
    FlutterSecureStorage? storage,
  }) : _client = client ?? http.Client(),
       _storage = storage ?? const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getToken();

    final headers = {'Content-Type': 'application/json'};

    if (token != null) headers['Authorization'] = 'Bearer $token';

    return headers;
  }

  Future<dynamic> get(String endpoint) async {
    final res = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(),
    );

    return _handleResponse(res);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final res = await _client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  Future<dynamic> patch(String endpoint, Map<String, dynamic> body) async {
    final res = await _client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  Future<dynamic> delete(String endpoint) async {
    final res = await _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _headers(),
    );

    return _handleResponse(res);
  }

  dynamic _handleResponse(http.Response res) {
    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : null;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    } else {
      throw ServerException(decoded?['message']);
    }
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'jwt');
  }
}
