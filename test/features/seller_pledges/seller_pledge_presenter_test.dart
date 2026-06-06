import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  group('SellerPledgePresenter', () {
    testWidgets('titleForStep maps pledge steps', (tester) async {
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
        SellerPledgePresenter.titleForStep(1, l10n),
        'Bước 1: Chụp ảnh hàng',
      );
      expect(
        SellerPledgePresenter.titleForStep(2, l10n),
        'Bước 2: Chấm điểm sản phẩm',
      );
      expect(
        SellerPledgePresenter.titleForStep(3, l10n),
        'Bước 3: Xác nhận ghi nhận',
      );
      expect(
        SellerPledgePresenter.titleForStep(99, l10n),
        'Bước 3: Xác nhận ghi nhận',
      );
    });

    testWidgets('categoryLabel and recordDescription localize values', (
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
        SellerPledgePresenter.categoryLabel(
          SellerPledgePresenter.otherCategory,
          l10n,
        ),
        'Khác',
      );
      expect(
        SellerPledgePresenter.recordDescription(
          score: '9.2',
          category: SellerPledgePresenter.otherCategory,
          l10n: l10n,
        ),
        'Điểm đánh giá 9.2/10 cho loại: Khác.',
      );
    });

    test('normalizedScore trims input and falls back for blank values', () {
      expect(SellerPledgePresenter.normalizedScore(' 9.2 '), '9.2');
      expect(SellerPledgePresenter.normalizedScore(''), '8.5');
      expect(SellerPledgePresenter.normalizedScore('   '), '8.5');
    });
  });
}
