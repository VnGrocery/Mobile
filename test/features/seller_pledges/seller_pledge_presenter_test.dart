import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vngrocery/features/seller_pledges/seller_pledge_presenter.dart';
import 'package:vngrocery/features/home/category_presenter.dart';
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

      // The description now names the category the way every other screen
      // does, instead of through a private list that no real category was in.
      expect(
        SellerPledgePresenter.recordDescription(
          score: '9.2',
          category: 'seafood',
          l10n: l10n,
        ),
        'Điểm đánh giá 9.2/10 cho loại: ${CategoryPresenter.label(l10n, 'seafood')}.',
      );
    });

    test('normalizedScore trims and invents nothing', () {
      expect(SellerPledgePresenter.normalizedScore(' 9.2 '), '9.2');
      // A Vietnamese keyboard gives a decimal comma; the server wants a dot.
      expect(SellerPledgePresenter.normalizedScore('8,5'), '8.5');
      // A blank field used to become '8.5' - a quality claim nobody made,
      // signed into the product's history and anchored on chain.
      expect(SellerPledgePresenter.normalizedScore(''), '');
      expect(SellerPledgePresenter.normalizedScore('   '), '');
    });

    test('isValidScore accepts a number from 0 to 10 and nothing else', () {
      expect(SellerPledgePresenter.isValidScore('9.2'), isTrue);
      expect(SellerPledgePresenter.isValidScore(' 0 '), isTrue);
      expect(SellerPledgePresenter.isValidScore('10'), isTrue);
      // Vietnamese keyboards produce a comma.
      expect(SellerPledgePresenter.isValidScore('8,5'), isTrue);
      expect(SellerPledgePresenter.isValidScore(''), isFalse);
      expect(SellerPledgePresenter.isValidScore('11'), isFalse);
      expect(SellerPledgePresenter.isValidScore('-1'), isFalse);
      expect(SellerPledgePresenter.isValidScore('tốt'), isFalse);
    });
  });
}
