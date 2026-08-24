import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/activity/activity_copy.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

Future<AppLocalizations> _vi() =>
    AppLocalizations.delegate.load(const Locale('vi'));

ActivityEvent _event(String action, {String status = ''}) => ActivityEvent(
  eventId: 'event-1',
  action: action,
  status: status,
  createdAt: DateTime.utc(2026, 4, 7),
);

void main() {
  test('a like, a love and a follow do not read as the same act', () async {
    final l10n = await _vi();

    final labels = {
      for (final kind in ['follow', 'like', 'love'])
        kind: ActivityCopy.label(l10n, _event('engagement.added', status: kind)),
    };

    expect(labels.values.toSet().length, 3);
    for (final label in labels.values) {
      expect(label, isNotEmpty);
      expect(label, isNot(contains('engagement')));
    }
  });

  test('taking a mark back is not written as making one', () async {
    final l10n = await _vi();

    for (final kind in ['follow', 'like', 'love']) {
      expect(
        ActivityCopy.label(l10n, _event('engagement.removed', status: kind)),
        isNot(ActivityCopy.label(l10n, _event('engagement.added', status: kind))),
      );
    }
  });

  test('the actions behind the rest of the trail read as Vietnamese', () async {
    final l10n = await _vi();

    const actions = [
      'buyer_check.completed',
      'product_comment.created',
      'product_comment.updated',
      'product_comment.deleted',
      'shop_review.created',
      'shop_review.updated',
      'shop_review.deleted',
      'pledge.committed',
      'pledge.revoked',
      'pledge.reanchored',
      'shop.updated',
      'account.created',
    ];

    for (final action in actions) {
      final label = ActivityCopy.label(l10n, _event(action));
      expect(label, isNot(contains(action)), reason: action);
      expect(label, isNotEmpty);
    }
  });

  test('an action nobody planned for shows itself rather than nothing', () async {
    final l10n = await _vi();

    // A row that vanishes because the server learned a new verb would make the
    // history quietly wrong, which is worse than showing a raw code.
    expect(ActivityCopy.label(l10n, _event('warehouse.moved')), 'warehouse.moved');
  });
}
