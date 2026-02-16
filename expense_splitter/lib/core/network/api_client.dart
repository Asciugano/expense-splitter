import 'dart:convert';

import 'package:expense_splitter/core/exception/exception.dart';
import 'package:expense_splitter/core/token/token_storage.dart';
import 'package:http/http.dart' as http;

enum Method { post, get, put, patch, delete }

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  final TokenStorage _storage;

  bool _isRefreshing = false;

  ApiClient({required this.baseUrl, http.Client? client, TokenStorage? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? TokenStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.getAccessToken();

    final headers = {'Content-Type': 'application/json'};

    if (token != null) headers['Authorization'] = 'Bearer $token';

    return headers;
  }

  Future<void> _refreshToken() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) throw ServerException("No refresh token");

    final res = await _client.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      await _storage.saveTokens(
        decoded["accessToken"],
        decoded["refreshToken"],
      );
    } else {
      await _storage.clear();
      throw ServerException("Session expired");
    }

    _isRefreshing = false;
  }

  Future<dynamic> _request({
    required Method method,
    required String endPoint,
    Map<String, dynamic>? body,
    bool retrying = false,
  }) async {
    final uri = Uri.parse('$baseUrl$endPoint');
    late http.Response res;

    switch (method) {
      case Method.get:
        res = await _client.get(uri, headers: await _headers());
        break;
      case Method.post:
        res = await _client.post(
          uri,
          headers: await _headers(),
          body: jsonEncode(body),
        );
        break;
      case Method.put:
        res = await _client.put(
          uri,
          headers: await _headers(),
          body: jsonEncode(body),
        );
        break;
      case Method.patch:
        res = await _client.patch(
          uri,
          headers: await _headers(),
          body: jsonEncode(body),
        );
        break;
      case Method.delete:
        res = await _client.delete(uri, headers: await _headers());
        break;

      default:
        throw ServerException('Invalid Method');
    }

    if (res.statusCode == 401 && !retrying) {
      await _refreshToken();
      return _request(
        method: method,
        endPoint: endPoint,
        body: body,
        retrying: true,
      );
    }

    final decoded = res.body.isNotEmpty ? jsonDecode(res.body) : null;

    if (res.statusCode >= 200 && res.statusCode < 300) return decoded;
    throw ServerException(decoded?['message']);
  }

  Future<dynamic> get(String endPoint) =>
      _request(method: Method.get, endPoint: endPoint);
  Future<dynamic> post(String endPoint, Map<String, dynamic>? body) =>
      _request(method: Method.post, endPoint: endPoint, body: body);
  Future<dynamic> put(String endPoint, Map<String, dynamic>? body) =>
      _request(method: Method.put, endPoint: endPoint, body: body);
  Future<dynamic> patch(String endPoint, Map<String, dynamic>? body) =>
      _request(method: Method.patch, endPoint: endPoint, body: body);
  Future<dynamic> delete(String endPoint) =>
      _request(method: Method.delete, endPoint: endPoint);
}
