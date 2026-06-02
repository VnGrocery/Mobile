import 'mock_data.dart';
import 'models.dart';

class AppDataHooks {
  AppDataHooks._();
  static final AppDataHooks instance = AppDataHooks._();

  final MockDb _db = MockDb.instance;

  List<Shop> getShops() => List.unmodifiable(_db.shops);

  Shop getShop(String id) => _db.shopById(id);

  List<Product> getProducts({String? shopId}) {
    final products = shopId == null || shopId.isEmpty
        ? _db.products
        : _db.productsOfShop(shopId);
    return List.unmodifiable(products);
  }

  Product getProduct(String id) => _db.productById(id);

  List<Review> getReviews(String shopId) =>
      List.unmodifiable(_db.reviewsOf(shopId));

  List<PledgeHistoryItem> getPledges(String productId) =>
      List.unmodifiable(_db.pledgesOf(productId));

  BuyerCheckResult getLastBuyerCheck() => _db.lastBuyerCheck;

  VoucherCheckResult checkVoucher({
    required String code,
    required String shopId,
    required int orderValue,
  }) =>
      _db.checkVoucher(code: code, shopId: shopId, orderValue: orderValue);

  List<UserVoucher> getUserVouchers(String userEmail) =>
      List.unmodifiable(_db.userVoucherWallet(userEmail));

  Voucher getVoucher(String voucherId) => _db.voucherById(voucherId);

  UserVoucher getUserVoucher(String userVoucherId) =>
      _db.userVoucherById(userVoucherId);

  UserVoucher saveVoucherToWallet({
    required String userEmail,
    required String voucherId,
  }) =>
      _db.saveVoucherToWallet(userEmail: userEmail, voucherId: voucherId);

  void useUserVoucher(String userVoucherId) =>
      _db.useUserVoucher(userVoucherId);

  void addProduct(Product product) => _db.addProduct(product);

  void addPledge(String productId, PledgeHistoryItem item) =>
      _db.addPledge(productId, item);

  String nextId() => _db.nextId();

  SellerDashboard getSellerDashboard(String? shopId) {
    final selectedShopId =
        shopId == null || shopId.isEmpty ? MockDb.demoShopId : shopId;
    final shop = _db.shopById(selectedShopId);
    final products = _db.productsOfShop(shop.id);
    final pledges = products.expand((p) => _db.pledgesOf(p.id)).toList();
    final pledgesToday =
        pledges.where((p) => p.time.startsWith('2026-05-30')).length;

    return SellerDashboard(
      shop: shop,
      products: List.unmodifiable(products),
      pledges: List.unmodifiable(pledges),
      pledgesToday: pledgesToday,
      warningCount: products.where((p) => p.freshnessScore < 60).length,
      trustGrade: _trustGrade(shop.rating),
    );
  }

  Shop saveShop({
    required String shopId,
    required String name,
    required String description,
    required String address,
  }) {
    final index = _db.shops.indexWhere((shop) => shop.id == shopId);
    final updated = Shop(
      id: shopId,
      name: name,
      address: address,
      rating: index >= 0 ? _db.shops[index].rating : 0,
      reviewCount: index >= 0 ? _db.shops[index].reviewCount : 0,
      description: description,
      logoUrl: index >= 0 ? _db.shops[index].logoUrl : null,
    );
    if (index >= 0) {
      _db.shops[index] = updated;
    } else {
      _db.shops.add(updated);
    }
    return updated;
  }

  String _trustGrade(double rating) {
    if (rating >= 4.7) return 'A';
    if (rating >= 4.3) return 'B';
    if (rating > 0) return 'C';
    return 'N/A';
  }
}

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
