import 'models.dart';
import 'repositories.dart';

export 'repositories.dart' show SellerDashboard;

class AppDataHooks {
  AppDataHooks._();
  static final AppDataHooks instance = AppDataHooks._();

  final AppRepositories _repos = AppRepositories.instance;

  List<Shop> getShops() => _repos.shops.all();

  Shop? getShopOrNull(String id) => _repos.shops.byIdOrNull(id);

  Shop getShop(String id) => _repos.shops.byId(id);

  List<Product> getProducts({String? shopId}) {
    return _repos.products.all(shopId: shopId);
  }

  Product? getProductOrNull(String id) => _repos.products.byIdOrNull(id);

  Product getProduct(String id) => _repos.products.byId(id);

  List<Review> getReviews(String shopId) => _repos.reviews.ofShop(shopId);

  List<PledgeHistoryItem> getPledges(String productId) =>
      _repos.pledges.ofProduct(productId);

  BuyerCheckResult getLastBuyerCheck() => _repos.buyerChecks.lastResult;

  VoucherCheckResult checkVoucher({
    required String code,
    required String shopId,
    required int orderValue,
  }) {
    return _repos.vouchers.check(
      code: code,
      shopId: shopId,
      orderValue: orderValue,
    );
  }

  List<UserVoucher> getUserVouchers(String userEmail) {
    return _repos.vouchers.wallet(userEmail);
  }

  Voucher? getVoucherOrNull(String voucherId) {
    return _repos.vouchers.byIdOrNull(voucherId);
  }

  Voucher getVoucher(String voucherId) => _repos.vouchers.byId(voucherId);

  UserVoucher? getUserVoucherOrNull(String userVoucherId) {
    return _repos.vouchers.userVoucherByIdOrNull(userVoucherId);
  }

  UserVoucher getUserVoucher(String userVoucherId) {
    return _repos.vouchers.userVoucherById(userVoucherId);
  }

  UserVoucher saveVoucherToWallet({
    required String userEmail,
    required String voucherId,
  }) {
    return _repos.vouchers.saveToWallet(
      userEmail: userEmail,
      voucherId: voucherId,
    );
  }

  UserVoucher addManualVoucherToWallet({
    required String userEmail,
    required String shopId,
    required String code,
    required String title,
    required String note,
    required String codeFormat,
    required DateTime expiresAt,
  }) {
    return _repos.vouchers.addManualToWallet(
      userEmail: userEmail,
      shopId: shopId,
      code: code,
      title: title,
      note: note,
      codeFormat: codeFormat,
      expiresAt: expiresAt,
    );
  }

  bool useUserVoucher(String userVoucherId) {
    return _repos.vouchers.useUserVoucher(userVoucherId);
  }

  void addProduct(Product product) => _repos.products.add(product);

  void addPledge(String productId, PledgeHistoryItem item) {
    _repos.pledges.add(productId, item);
  }

  String nextId() => _repos.ids.nextId();

  SellerDashboard getSellerDashboard(String? shopId) {
    return _repos.seller.dashboard(shopId);
  }

  Shop saveShop({
    required String shopId,
    required String name,
    required String description,
    required String address,
  }) {
    return _repos.shops.save(
      shopId: shopId,
      name: name,
      description: description,
      address: address,
    );
  }
}
