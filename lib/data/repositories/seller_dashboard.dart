import '../models.dart';

class SellerDashboard {
  final Shop shop;
  final List<Product> products;
  final List<PledgeHistoryItem> pledges;
  final int pledgesToday;
  final int warningCount;
  final String trustGrade;

  const SellerDashboard({
    required this.shop,
    required this.products,
    required this.pledges,
    required this.pledgesToday,
    required this.warningCount,
    required this.trustGrade,
  });
}
