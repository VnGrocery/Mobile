import 'app_data_config.dart';
import 'mock_json_data.dart';
import 'models.dart';

class MockDb {
  MockDb._() {
    _seed(appMockJson);
  }

  static final MockDb instance = MockDb._();

  static const String demoShopId = AppDataConfig.demoShopId;

  final List<Shop> shops = [];
  final List<Product> products = [];
  final Map<String, List<Review>> reviewsByShop = {};
  final Map<String, List<PledgeHistoryItem>> pledgesByProduct = {};
  final List<Voucher> vouchers = [];
  final List<UserVoucher> userVouchers = [];

  late BuyerCheckResult lastBuyerCheck;

  void _seed(Map<String, Object?> json) {
    shops
      ..clear()
      ..addAll(_list(json['shops']).map(Shop.fromJson));
    products
      ..clear()
      ..addAll(_list(json['products']).map(Product.fromJson));
    reviewsByShop
      ..clear()
      ..addAll(_groupedList(json['reviewsByShop'], Review.fromJson));
    pledgesByProduct
      ..clear()
      ..addAll(
        _groupedList(json['pledgesByProduct'], PledgeHistoryItem.fromJson),
      );
    vouchers
      ..clear()
      ..addAll(_list(json['vouchers']).map(Voucher.fromJson));
    userVouchers
      ..clear()
      ..addAll(_list(json['userVouchers']).map(UserVoucher.fromJson));
    lastBuyerCheck = BuyerCheckResult.fromJson(_map(json['lastBuyerCheck']));
  }

  Shop? shopByIdOrNull(String id) => shops.where((s) => s.id == id).firstOrNull;

  Shop shopById(String id) {
    final shop = shopByIdOrNull(id);
    if (shop == null) throw StateError('Shop not found: $id');
    return shop;
  }

  Product? productByIdOrNull(String id) =>
      products.where((p) => p.id == id).firstOrNull;

  Product productById(String id) {
    final product = productByIdOrNull(id);
    if (product == null) throw StateError('Product not found: $id');
    return product;
  }

  List<Product> productsOfShop(String shopId) =>
      products.where((p) => p.shopId == shopId).toList();

  List<Review> reviewsOf(String shopId) => reviewsByShop[shopId] ?? const [];

  List<PledgeHistoryItem> pledgesOf(String productId) =>
      pledgesByProduct[productId] ?? const [];

  Voucher? voucherByIdOrNull(String id) =>
      vouchers.where((voucher) => voucher.id == id).firstOrNull;

  Voucher voucherById(String id) {
    final voucher = voucherByIdOrNull(id);
    if (voucher == null) throw StateError('Voucher not found: $id');
    return voucher;
  }

  List<UserVoucher> userVoucherWallet(String userEmail) => userVouchers
      .where((item) => item.userEmail.toLowerCase() == userEmail.toLowerCase())
      .toList();

  UserVoucher? userVoucherByIdOrNull(String id) =>
      userVouchers.where((item) => item.id == id).firstOrNull;

  UserVoucher userVoucherById(String id) {
    final userVoucher = userVoucherByIdOrNull(id);
    if (userVoucher == null) throw StateError('User voucher not found: $id');
    return userVoucher;
  }

  UserVoucher? walletItemForVoucher({
    required String userEmail,
    required String voucherId,
  }) {
    final matches = userVouchers.where(
      (item) =>
          item.userEmail.toLowerCase() == userEmail.toLowerCase() &&
          item.voucherId == voucherId,
    );
    return matches.isEmpty ? null : matches.first;
  }

  UserVoucher saveVoucherToWallet({
    required String userEmail,
    required String voucherId,
  }) {
    final existing =
        walletItemForVoucher(userEmail: userEmail, voucherId: voucherId);
    if (existing != null) return existing;
    final created = UserVoucher(
      id: nextId(),
      userEmail: userEmail,
      voucherId: voucherId,
    );
    userVouchers.insert(0, created);
    return created;
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
    final voucher = Voucher(
      id: nextId(),
      code: code.trim().toUpperCase(),
      title: title.trim().isEmpty ? 'Voucher tự nhập' : title.trim(),
      shopId: shopId,
      discountValue: 0,
      isPercent: false,
      minSpend: 0,
      expiresAt: expiresAt,
      manual: true,
      note: note.trim(),
      codeFormat: codeFormat,
    );
    vouchers.insert(0, voucher);
    final userVoucher = UserVoucher(
      id: nextId(),
      userEmail: userEmail,
      voucherId: voucher.id,
    );
    userVouchers.insert(0, userVoucher);
    return userVoucher;
  }

  bool useUserVoucher(String userVoucherId) {
    final item = userVoucherByIdOrNull(userVoucherId);
    if (item == null) return false;
    if (item.isUsed) return true;
    item.used = true;
    item.usedAt = DateTime.now();
    return true;
  }

  VoucherCheckResult checkVoucher({
    required String code,
    required String shopId,
    required int orderValue,
    DateTime? now,
  }) {
    final normalizedCode = code.trim().toUpperCase();
    final currentTime = now ?? DateTime.now();
    final voucher = vouchers
        .where((item) => item.code.toUpperCase() == normalizedCode)
        .firstOrNull;

    if (normalizedCode.isEmpty) {
      return VoucherCheckResult(
        voucher: null,
        valid: false,
        message: 'Nhập mã voucher để kiểm tra',
        discountAmount: 0,
        finalPrice: orderValue,
      );
    }
    if (voucher == null) {
      return VoucherCheckResult(
        voucher: null,
        valid: false,
        message: 'Không tìm thấy voucher này',
        discountAmount: 0,
        finalPrice: orderValue,
      );
    }
    if (!voucher.isActive) {
      return VoucherCheckResult(
        voucher: voucher,
        valid: false,
        message: 'Voucher đang tạm khóa',
        discountAmount: 0,
        finalPrice: orderValue,
      );
    }
    if (voucher.shopId != shopId) {
      return VoucherCheckResult(
        voucher: voucher,
        valid: false,
        message: 'Voucher không áp dụng cho cửa hàng này',
        discountAmount: 0,
        finalPrice: orderValue,
      );
    }
    if (currentTime.isAfter(voucher.expiresAt)) {
      return VoucherCheckResult(
        voucher: voucher,
        valid: false,
        message: 'Voucher đã hết hạn',
        discountAmount: 0,
        finalPrice: orderValue,
      );
    }
    if (orderValue < voucher.minSpend) {
      return VoucherCheckResult(
        voucher: voucher,
        valid: false,
        message: 'Đơn cần tối thiểu ${voucher.minSpend}đ để dùng mã này',
        discountAmount: 0,
        finalPrice: orderValue,
      );
    }

    final discount = voucher.isPercent
        ? (orderValue * voucher.discountValue / 100).round()
        : voucher.discountValue;
    final cappedDiscount = discount.clamp(0, orderValue).toInt();
    return VoucherCheckResult(
      voucher: voucher,
      valid: true,
      message: 'Voucher hợp lệ',
      discountAmount: cappedDiscount,
      finalPrice: orderValue - cappedDiscount,
    );
  }

  void addProduct(Product p) => products.add(p);

  void addPledge(String productId, PledgeHistoryItem e) {
    pledgesByProduct.putIfAbsent(productId, () => []).insert(0, e);
  }

  int _seq = 2000;
  String nextId() => 'g${_seq++}';
}

List<Map<String, Object?>> _list(Object? value) {
  return (value as List<Object?>).map(_map).toList();
}

Map<String, Object?> _map(Object? value) {
  return (value as Map<Object?, Object?>).cast<String, Object?>();
}

Map<String, List<T>> _groupedList<T>(
  Object? value,
  T Function(Map<String, Object?> json) parse,
) {
  return _map(value).map(
    (key, item) => MapEntry(key, _list(item).map(parse).toList()),
  );
}
