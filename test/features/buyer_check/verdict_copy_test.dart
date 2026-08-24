import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/buyer_check/verdict_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Future<AppLocalizations> _vi() =>
    AppLocalizations.delegate.load(const Locale('vi'));

void main() {
  test('every verdict the server sends reads as Vietnamese', () async {
    final l10n = await _vi();

    for (final code in ['trusted', 'warning', 'high_risk', 'no_pledge']) {
      final label = VerdictCopy.label(l10n, code);
      // The whole point: the code itself must never reach the screen.
      expect(label, isNot(contains(code)));
      expect(label, isNotEmpty);
    }
  });

  test('a code nobody planned for says so instead of showing itself', () async {
    final l10n = await _vi();

    expect(VerdictCopy.label(l10n, 'something_new'), l10n.verdictUnknown);
    expect(VerdictCopy.label(l10n, ''), l10n.verdictUnknown);
  });
}
