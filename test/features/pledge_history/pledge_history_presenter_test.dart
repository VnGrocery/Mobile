import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/pledge_history/pledge_history_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/l10n/app_localizations_en.dart';
import 'package:vngrocery/l10n/app_localizations_vi.dart';

PledgeHistoryItem _item(Map<String, Object?> json) =>
    PledgeHistoryItem.fromJson(json);

void main() {
  final AppLocalizations vi = AppLocalizationsVi();
  final AppLocalizations en = AppLocalizationsEn();

  group('PledgeHistoryPresenter', () {
    test('translates the category key instead of showing it raw', () {
      final item = _item({'score': 8.75, 'category': 'fresh_produce'});

      expect(
        PledgeHistoryPresenter.description(vi, item),
        'Điểm 8.8/10 · Nông sản tươi',
      );
      expect(
        PledgeHistoryPresenter.description(en, item),
        'Score 8.8/10 · Fresh produce',
      );
    });

    test('a score with no category still reads as a sentence', () {
      final item = _item({'score': 9});

      expect(PledgeHistoryPresenter.description(vi, item), 'Điểm 9.0/10');
    });

    test('server wording wins over the generated line', () {
      final item = _item({
        'score': 8,
        'category': 'meat',
        'description': 'Lô hàng đã được kiểm tra lại',
      });

      expect(
        PledgeHistoryPresenter.description(vi, item),
        'Lô hàng đã được kiểm tra lại',
      );
    });

    test('no score and no wording gives nothing to render', () {
      expect(PledgeHistoryPresenter.description(vi, _item({})), '');
    });

    test('falls back to a localized title', () {
      expect(PledgeHistoryPresenter.title(vi, _item({})), 'Ghi nhận độ tươi');
      expect(PledgeHistoryPresenter.title(en, _item({})), 'Freshness record');
      expect(
        PledgeHistoryPresenter.title(vi, _item({'title': 'Neo lại hash'})),
        'Neo lại hash',
      );
    });
  });
}
