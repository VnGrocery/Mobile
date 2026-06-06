import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/buyer_check/buyer_check_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

void main() {
  group('BuyerCheckPresenter', () {
    const near = BuyerCheckResult(
      actualScore: 92,
      locationStatus: 'near',
      verdict: 'Ổn',
    );
    const far = BuyerCheckResult(
      actualScore: 61,
      locationStatus: 'far',
      verdict: 'Cần xem lại',
    );

    test('isNearStore follows locationStatus', () {
      expect(BuyerCheckPresenter.isNearStore(near), isTrue);
      expect(BuyerCheckPresenter.isNearStore(far), isFalse);
    });

    test('locationIcon and color reflect distance state', () {
      expect(BuyerCheckPresenter.locationIcon(near), Icons.gps_fixed);
      expect(BuyerCheckPresenter.locationIcon(far), Icons.gps_off);
      expect(BuyerCheckPresenter.locationColor(near), AppColors.trustGreen);
      expect(
        BuyerCheckPresenter.locationColor(far),
        AppColors.warningOrange,
      );
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
  });
}
