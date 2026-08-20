import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vngrocery/core/network/api_client.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/reviews/controllers/review_cubit.dart';

/// Repositories whose backend always rejects the request.
AppRepositories _brokenBackend() {
  return AppRepositories.forTesting(
    MockDb.instance,
    RemoteDataSource(
      ApiClient(
        baseUrl: 'http://localhost',
        tokenReader: () => 'token',
        client: MockClient((_) async => http.Response('{"error":"nope"}', 500)),
      ),
    ),
  );
}

void main() {
  group('ReviewCubit', () {
    test('reports a failed send instead of staying silent', () async {
      final cubit = ReviewCubit(shopId: 's1', repositories: _brokenBackend());
      cubit.setRating(5);

      await cubit.submit('Rau tươi lắm');

      // The screen used to check only `submitted`, so a rejected review looked
      // exactly like never pressing the button.
      expect(cubit.state.submitting, isFalse);
      expect(cubit.state.submitted, isFalse);
      expect(cubit.state.failed, isTrue);

      await cubit.close();
    });

    test('a fresh submit clears the previous failure', () async {
      final cubit = ReviewCubit(shopId: 's1', repositories: _brokenBackend());
      cubit.setRating(4);
      await cubit.submit('lần một');
      expect(cubit.state.failed, isTrue);

      // Mid-flight the flag is cleared, so the old error cannot linger on
      // screen while a retry is running.
      final retry = cubit.submit('lần hai');
      expect(cubit.state.failed, isFalse);
      expect(cubit.state.submitting, isTrue);
      await retry;

      await cubit.close();
    });

    test('does nothing without a rating or a comment', () async {
      final cubit = ReviewCubit(shopId: 's1', repositories: _brokenBackend());

      await cubit.submit('');
      expect(cubit.state.submitting, isFalse);
      expect(cubit.state.failed, isFalse);

      cubit.setRating(3);
      await cubit.submit('   ');
      expect(cubit.state.failed, isFalse);

      await cubit.close();
    });
  });
}
