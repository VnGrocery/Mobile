import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';

void main() {
  group('SellerProductPresenter', () {
    testWidgets('stateLabel maps known statuses', (tester) async {
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

      // The server writes these lower case; the mock rows carry the older
      // capitalised spelling, and both have to read the same.
      expect(SellerProductPresenter.stateLabel('published', l10n), 'Đang bán');
      expect(SellerProductPresenter.stateLabel('Published', l10n), 'Đang bán');
      expect(SellerProductPresenter.stateLabel('draft', l10n), 'Bản nháp');
      expect(SellerProductPresenter.stateLabel('archived', l10n), 'Đã ẩn');
      expect(SellerProductPresenter.stateLabel('Paused', l10n), 'Paused');
    });

    test('statusForeground maps statuses to expected colors', () {
      expect(
        SellerProductPresenter.statusForeground('published'),
        AppColors.trustGreen,
      );
      expect(
        SellerProductPresenter.statusForeground('Published'),
        AppColors.trustGreen,
      );
      expect(SellerProductPresenter.statusForeground('draft'), Colors.grey);
      expect(
        SellerProductPresenter.statusForeground('archived'),
        AppColors.warningOrange,
      );
    });

    test('parsePrice strips non-digits and falls back to zero', () {
      expect(SellerProductPresenter.parsePrice('120.000đ'), 120000);
      expect(SellerProductPresenter.parsePrice(' 85,500 VND '), 85500);
      expect(SellerProductPresenter.parsePrice('abc'), 0);
    });

    test('parseTags trims values and drops empty tags', () {
      expect(SellerProductPresenter.parseTags(' sạch, ngon ,, hữu cơ , '), [
        'sạch',
        'ngon',
        'hữu cơ',
      ]);
    });

    testWidgets('freshnessNote reflects image presence', (tester) async {
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
        SellerProductPresenter.freshnessNote(true, l10n),
        'Sản phẩm mới tạo, đã có ảnh.',
      );
      expect(
        SellerProductPresenter.freshnessNote(false, l10n),
        'Sản phẩm mới tạo.',
      );
    });
  });
}
