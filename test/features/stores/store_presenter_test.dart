import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/stores/store_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';

void main() {
  testWidgets('StorePresenter.shareText formats shop summary', (tester) async {
    const shop = Shop(
      id: 's1',
      name: 'Chợ Xanh',
      address: '12 Nguyễn Trãi',
      rating: 4.7,
      reviewCount: 128,
      description: 'Cửa hàng thực phẩm sạch',
    );
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
      StorePresenter.shareText(shop, l10n),
      'Chợ Xanh\n12 Nguyễn Trãi\n4.7 điểm đánh giá - 128 lượt đánh giá',
    );
  });
}
