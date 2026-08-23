import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/core/network/api_exception.dart';

ApiClient _client(http.Client inner) => ApiClient(
  baseUrl: 'http://localhost:5050',
  tokenReader: () => 'token',
  client: inner,
);

void main() {
  group('ApiClient reads bodies as UTF-8', () {
    test('a JSON object with no charset header keeps its tone marks', () async {
      // http.Response.body falls back to latin1 without a charset, which used
      // to turn "Rau Cô Ba" into "Rau CÃ´ Ba" on every screen.
      final client = _client(
        MockClient(
          (_) async => http.Response.bytes(
            utf8.encode(jsonEncode({'name': 'Rau Cô Ba'})),
            200,
          ),
        ),
      );

      expect(await client.get('/shops'), {'name': 'Rau Cô Ba'});
    });

    test('a JSON list with no charset header does too', () async {
      final client = _client(
        MockClient(
          (_) async => http.Response.bytes(
            utf8.encode(jsonEncode(['Chợ Bến Thành'])),
            200,
          ),
        ),
      );

      expect(await client.getList('/shops'), ['Chợ Bến Thành']);
    });

    test('an error message keeps its tone marks', () async {
      final client = _client(
        MockClient(
          (_) async => http.Response.bytes(
            utf8.encode(jsonEncode({'error': 'Cửa hàng không tồn tại'})),
            404,
          ),
        ),
      );

      await expectLater(
        client.get('/me/shop'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Cửa hàng không tồn tại',
          ),
        ),
      );
    });
  });
}
