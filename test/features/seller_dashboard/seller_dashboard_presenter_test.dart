import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories/seller_dashboard.dart';
import 'package:vngrocery/features/seller_dashboard/seller_dashboard_presenter.dart';

void main() {
  group('SellerDashboardPresenter', () {
    const shop = Shop(
      id: 's1',
      name: 'Demo shop',
      address: '123 Demo',
      rating: 4.8,
      reviewCount: 120,
      description: 'desc',
    );

    test('canCreatePledge requires products', () {
      final empty = SellerDashboard(
        shop: shop,
        products: const [],
        pledges: const [],
        pledgesToday: 0,
        warningCount: 0,
        trustGrade: 'A',
      );
      final nonEmpty = SellerDashboard(
        shop: shop,
        products: [
          Product(
            id: 'p1',
            shopId: 's1',
            name: 'Thịt bò',
            description: 'desc',
            category: 'Thịt bò',
            freshnessScore: 88,
            freshnessNote: 'Ổn',
            price: 100000,
            tags: const ['mới'],
            status: 'Published',
          ),
        ],
        pledges: const [],
        pledgesToday: 1,
        warningCount: 0,
        trustGrade: 'A',
      );

      expect(SellerDashboardPresenter.canCreatePledge(empty), isFalse);
      expect(SellerDashboardPresenter.canCreatePledge(nonEmpty), isTrue);
    });
  });
}
