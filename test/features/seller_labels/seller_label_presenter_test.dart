import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_labels/seller_label_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/l10n/app_localizations_en.dart';
import 'package:vngrocery/l10n/app_localizations_vi.dart';

void main() {
  final AppLocalizations vi = AppLocalizationsVi();
  final AppLocalizations en = AppLocalizationsEn();

  group('SellerLabelPresenter.clipboardText', () {
    test('lists every part of the label in the reader language', () {
      expect(
        SellerLabelPresenter.clipboardText(
          vi,
          pledgeId: 'pl-01',
          bundleId: 'lot-9',
          bundleToken: 'tok',
        ),
        'VnGrocery Check\nMã ghi nhận: pl-01\nMã lô: lot-9\nToken: tok',
      );
      expect(
        SellerLabelPresenter.clipboardText(
          en,
          pledgeId: 'pl-01',
          bundleId: 'lot-9',
          bundleToken: 'tok',
        ),
        'VnGrocery Check\nPledge ID: pl-01\nBundle ID: lot-9\nToken: tok',
      );
    });

    test('skips the lines with nothing to print', () {
      // Opening the label without a fresh commit leaves no bundle or token;
      // the old text printed the labels anyway with a blank after each.
      expect(
        SellerLabelPresenter.clipboardText(vi, pledgeId: 'pl-01'),
        'VnGrocery Check\nMã ghi nhận: pl-01',
      );
    });
  });
}
