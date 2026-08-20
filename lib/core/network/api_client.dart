import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

typedef TokenReader = String? Function();
typedef UnauthorizedHandler = Future<String?> Function();

class ApiClient {
  ApiClient({
    required this.baseUrl,
    required TokenReader tokenReader,
    http.Client? client,
  }) : _tokenReader = tokenReader,
       _client = client ?? http.Client();

  /// 10.0.2.2 is the Android emulator's alias for the host machine. Port 5000 is
  /// what docker-compose publishes for the API; 8080 on the host is the IPFS
  /// gateway, not the API.
  ///
  /// Override for a physical device or a different port:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5000
  static const defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  final String baseUrl;
  final TokenReader _tokenReader;
  final http.Client _client;
  UnauthorizedHandler? _unauthorizedHandler;

  void setUnauthorizedHandler(UnauthorizedHandler handler) {
    _unauthorizedHandler = handler;
  }

  Uri _uri(String path, [Map<String, Object?> query = const {}]) {
    final root = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final uri = Uri.parse('$root$path');
    final values = <String, String>{
      for (final entry in query.entries)
        if (entry.value != null && entry.value.toString().isNotEmpty)
          entry.key: entry.value.toString(),
    };
    return values.isEmpty ? uri : uri.replace(queryParameters: values);
  }

  Map<String, String> _headers({bool json = true}) {
    final token = _tokenReader();
    return {
      if (json) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, Object?>> get(
    String path, {
    Map<String, Object?> query = const {},
  }) async {
    return _decode(
      await _send(() => _client.get(_uri(path, query), headers: _headers())),
    );
  }

  Future<List<Object?>> getList(
    String path, {
    Map<String, Object?> query = const {},
  }) async {
    final response = await _send(
      () => _client.get(_uri(path, query), headers: _headers()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      _decode(response);
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ApiException(500, 'Invalid server response');
    }
    return decoded.cast<Object?>();
  }

  Future<Map<String, Object?>> post(
    String path, {
    Object? body,
    bool retryUnauthorized = true,
  }) async {
    return _decode(
      await _send(
        () => _client.post(
          _uri(path),
          headers: _headers(),
          body: jsonEncode(body ?? const {}),
        ),
        retryUnauthorized: retryUnauthorized,
      ),
    );
  }

  Future<Map<String, Object?>> put(String path, {Object? body}) async {
    return _decode(
      await _send(
        () => _client.put(
          _uri(path),
          headers: _headers(),
          body: jsonEncode(body ?? const {}),
        ),
      ),
    );
  }

  Future<Map<String, Object?>> patch(String path, {Object? body}) async {
    return _decode(
      await _send(
        () => _client.patch(
          _uri(path),
          headers: _headers(),
          body: jsonEncode(body ?? const {}),
        ),
      ),
    );
  }

  Future<Map<String, Object?>> delete(String path, {Object? body}) async {
    return _decode(
      await _send(
        () => _client.delete(
          _uri(path),
          headers: _headers(),
          body: body == null ? null : jsonEncode(body),
        ),
      ),
    );
  }

  Future<Map<String, Object?>> multipart(
    String path, {
    required Uint8List bytes,
    required String filename,
    String field = 'image',
    Map<String, String> fields = const {},
  }) async {
    Future<http.Response> send() async {
      final request = http.MultipartRequest('POST', _uri(path))
        ..headers.addAll(_headers(json: false))
        ..fields.addAll(fields)
        ..files.add(
          http.MultipartFile.fromBytes(field, bytes, filename: filename),
        );
      return http.Response.fromStream(await _client.send(request));
    }

    return _decode(await _send(send));
  }

  Map<String, Object?> _decode(http.Response response) {
    Object? decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        decoded = null;
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final map = decoded is Map
          ? decoded.cast<String, Object?>()
          : const <String, Object?>{};
      throw ApiException(
        response.statusCode,
        map['error']?.toString() ?? 'Server error (${response.statusCode})',
      );
    }
    if (decoded == null) return const {};
    if (decoded is! Map) {
      throw const ApiException(500, 'Invalid server response');
    }
    return decoded.cast<String, Object?>();
  }

  Future<http.Response> _send(
    Future<http.Response> Function() request, {
    bool retryUnauthorized = true,
  }) async {
    var response = await request();
    if (response.statusCode == 401 &&
        retryUnauthorized &&
        _unauthorizedHandler != null) {
      final token = await _unauthorizedHandler!();
      if (token != null && token.isNotEmpty) {
        response = await request();
      }
    }
    return response;
  }
}
