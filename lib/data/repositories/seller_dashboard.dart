import 'package:vngrocery/data/models.dart';

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

  /// A shop nobody has rated yet has no grade. It used to be given the letters
  /// 'N/A', which the screens then printed at Vietnamese readers as
  /// "Hang N/A - 0.0 diem".
  bool get isRated => trustGrade.isNotEmpty;
}
