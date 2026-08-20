import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';

/// A real bundleToken issued by the server during an end-to-end run.
const _token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
    'eyJidW5kbGVJZCI6ImUyZS1idW5kbGUtMTY1OTIxNzg3MjIwOTg0IiwiY29tbWl0dGVkQXQiOiIyMDI2LTA4LTIwVDEwOjE2OjI0WiIsImV4cCI6MTc4NzIyMjc4NCwiaWF0IjoxNzg3MjIwOTg0LCJpc3MiOiJ2bmdyb2NlcnkiLCJub25jZSI6ImE3Zjg0OWFhLWVmNTUtNGUzMS05NTNmLTgzMmMwNjcwYjczMCIsInBsZWRnZUlkIjoiMzcwYzM2OWItZjIyZi00MWFiLWFjMDAtMDY4YTM0NWYyZjg5IiwicHJvZHVjdElkIjoiY2QwMmFkOGMtYTM2Mi00NzdjLWFkZmMtMTJhYmZjMzM0YzhiIiwicXJWZXJzaW9uIjoiYnVuZGxlX3FyX3YxIiwic2VsbGVySWQiOiI3OTM0MWZmNS04ZDczLTRhMzEtYTNmMS0zZTcwYTE0MjMzZjMiLCJzaG9wSWQiOiJjMmVkNDQ5OC1jNjYxLTQyYzItYTA4MS04NjlhMzc2MmFlNDIiLCJ0b2tlblR5cGUiOiJidW5kbGVfcXIiLCJ3YXRlcm1hcmsiOiIxMjJiNzJhYWFiIn0.'
    'OIArjwlizNrHcBklhDbuO5_0OyJDxP-FgUM2cG17KVo';

void main() {
  group('BundleToken', () {
    test('reads every claim the buyer check needs', () {
      final token = BundleToken.tryParse(_token);

      expect(token, isNotNull);
      expect(token!.bundleId, 'e2e-bundle-165921787220984');
      expect(token.pledgeId, '370c369b-f22f-41ab-ac00-068a345f2f89');
      expect(token.shopId, 'c2ed4498-c661-42c2-a081-869a3762ae42');
      expect(token.productId, 'cd02ad8c-a362-477c-adfc-12abfc334c8b');
      expect(token.qrVersion, 'bundle_qr_v1');
      expect(token.isSupported, isTrue);
      expect(token.isUsable, isTrue);
      expect(token.raw, _token);
    });

    test('surrounding whitespace from a scan is ignored', () {
      expect(BundleToken.tryParse('  $_token \n'), isNotNull);
    });

    test('accepts a label printed as a link', () {
      final token = BundleToken.tryParse('vngrocery://check?token=$_token');
      expect(token?.bundleId, 'e2e-bundle-165921787220984');
    });

    test('reports expiry against the exp claim', () {
      final token = BundleToken.tryParse(_token)!;

      expect(token.expiresAt, isNotNull);
      expect(
        token.isExpired(token.expiresAt!.add(const Duration(minutes: 1))),
        isTrue,
      );
      expect(
        token.isExpired(token.expiresAt!.subtract(const Duration(minutes: 1))),
        isFalse,
      );
    });

    test('rejects anything that is not one of our codes', () {
      expect(BundleToken.tryParse(''), isNull);
      expect(BundleToken.tryParse('https://example.com'), isNull);
      expect(BundleToken.tryParse('just some text'), isNull);
      expect(BundleToken.tryParse('a.b.c'), isNull);
    });

    test('rejects a JWT that carries no bundle', () {
      // header.payload({"foo":"bar"}).signature
      const other = 'eyJhbGciOiJIUzI1NiJ9.eyJmb28iOiJiYXIifQ.sig';
      expect(BundleToken.tryParse(other), isNull);
    });

    test('flags a QR version this build does not know', () {
      const unknown = BundleToken(
        raw: 'x',
        bundleId: 'b',
        pledgeId: 'p',
        shopId: 's',
        qrVersion: 'bundle_qr_v9',
      );
      expect(unknown.isSupported, isFalse);
    });
  });
}
