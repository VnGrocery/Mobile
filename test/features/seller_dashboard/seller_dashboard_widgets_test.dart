import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_dashboard/widgets/seller_dashboard_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/theme/app_theme.dart';

Widget _host(Widget child) => MaterialApp(
  locale: const Locale('vi'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: AppTheme.light,
  home: Scaffold(body: child),
);

/// WCAG relative luminance.
double _luminance(Color color) {
  double channel(double value) {
    final v = value;
    return v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4) as double;
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('label contrast', () {
    // The label size is the most used text in the app - every metric tile,
    // every timestamp - and it used to sit at ~2.6:1 on the grey card, which
    // is unreadable in the sunlight this app is used in.
    test('secondary text clears 4.5:1 on the card and on the page', () {
      expect(
        _contrast(AppColors.textSecondary, AppPalette.light.card),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(AppColors.textSecondary, AppPalette.light.appBackground),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(AppPalette.light.textSecondary, AppPalette.light.card),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(AppPalette.dark.textSecondary, AppPalette.dark.card),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  testWidgets('the pledge card looks locked when there is nothing to record', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _host(
        CreateSellerPledgeCard(
          canCreatePledge: false,
          onTap: () => tapped = true,
        ),
      ),
    );

    // It used to stay full green with a forward arrow, so the most prominent
    // thing on the screen invited a tap that did nothing.
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsNothing);
    final material = tester.widget<Material>(
      find.ancestor(of: find.byIcon(Icons.lock_outline), matching: find.byType(Material)).first,
    );
    expect(material.color, isNot(AppColors.primaryGreen));

    await tester.tap(find.byType(InkWell));
    expect(tapped, isFalse);
  });

  testWidgets('the pledge card invites a tap when a record can be made', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _host(
        CreateSellerPledgeCard(
          canCreatePledge: true,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  testWidgets('the history button is disabled when there is no history', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        SellerDashboardActions(onOpenProducts: () {}, onOpenHistory: null),
      ),
    );

    final buttons = tester
        .widgetList<OutlinedButton>(find.byType(OutlinedButton))
        .toList();
    expect(buttons, hasLength(2));
    expect(buttons.first.onPressed, isNotNull);
    // It used to be tappable and the handler returned silently.
    expect(buttons.last.onPressed, isNull);
  });
}
