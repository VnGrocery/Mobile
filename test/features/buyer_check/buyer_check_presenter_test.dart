import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/network/api_exception.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/buyer_check/buyer_check_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

void main() {
  group('BuyerCheckPresenter', () {
    // The values the server actually sends. `near` and `far` were invented
    // here and match nothing the API produces.
    const near = BuyerCheckResult(
      actualScore: 9.2,
      locationStatus: 'verified_near_shop',
      verdict: 'trusted',
    );
    const far = BuyerCheckResult(
      actualScore: 6.1,
      locationStatus: 'too_far_from_shop',
      verdict: 'warning',
    );

    test('isNearStore follows locationStatus', () {
      expect(BuyerCheckPresenter.isNearStore(near), isTrue);
      expect(BuyerCheckPresenter.isNearStore(far), isFalse);
    });

    test('locationIcon and color reflect distance state', () {
      expect(BuyerCheckPresenter.locationIcon(near), Icons.gps_fixed);
      expect(BuyerCheckPresenter.locationIcon(far), Icons.gps_off);
      expect(BuyerCheckPresenter.locationColor(near), AppColors.trustGreen);
      expect(BuyerCheckPresenter.locationColor(far), AppColors.warningOrange);
    });

    testWidgets('location labels and descriptions reflect distance state', (
      tester,
    ) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(
        BuyerCheckPresenter.locationLabel(near, l10n),
        'Ghi nhận tại quầy',
      );
      expect(
        BuyerCheckPresenter.locationLabel(far, l10n),
        'Cần thêm lượt xác nhận',
      );
      expect(
        BuyerCheckPresenter.locationDescription(near, l10n),
        'Bạn đang ở gần cửa hàng. Ghi nhận này được tính vào dữ liệu gần đây.',
      );
      expect(
        BuyerCheckPresenter.locationDescription(far, l10n),
        'Bạn không ở gần cửa hàng. Ghi nhận này chỉ dùng để tham khảo.',
      );
    });

    testWidgets('a failed check never shows the server raw English', (
      tester,
    ) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // The wait is the only part of a 429 the shopper can act on.
      expect(
        BuyerCheckPresenter.errorMessage(
          const ApiException(429, 'rate limit exceeded', retryAfterMinutes: 12),
          l10n,
        ),
        contains('12 phút'),
      );
      // A 429 with no wait must not invent one.
      expect(
        BuyerCheckPresenter.errorMessage(
          const ApiException(429, 'rate limit exceeded'),
          l10n,
        ),
        'Chưa kiểm tra được mã này. Bạn thử lại giúp nhé.',
      );
      expect(
        BuyerCheckPresenter.errorMessage(
          const ApiException(400, 'invalid buyer check request'),
          l10n,
        ),
        isNot(contains('invalid')),
      );
      // Anything that is not a response at all never reached the server.
      expect(
        BuyerCheckPresenter.errorMessage(Exception('socket closed'), l10n),
        'Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại nhé.',
      );
    });
  });
}
