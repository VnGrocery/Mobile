import 'models.dart';

/// Kho dữ liệu giả (singleton) — nội dung port từ MockData.kt, bổ sung
/// thêm timeline ghi nhận & kết quả buyer-check để demo đầy đủ luồng.
class MockDb {
  MockDb._();
  static final MockDb instance = MockDb._();

  /// shopId mặc định gắn cho tài khoản demo (seller sở hữu shop s1).
  static const String demoShopId = 's1';

  final List<Shop> shops = [
    const Shop(
      id: 's1',
      name: 'Cửa hàng thực phẩm sạch Organic',
      address: '123 Đường ABC, Quận 1, TP. Hồ Chí Minh',
      rating: 4.8,
      reviewCount: 120,
      description: 'Chuyên cung cấp thịt tươi sống đạt chuẩn quốc tế.',
    ),
    const Shop(
      id: 's2',
      name: 'Ba Huân Food',
      address: '456 Đường XYZ, Quận 7, TP. Hồ Chí Minh',
      rating: 4.5,
      reviewCount: 85,
      description: 'Được nhiều người mua đánh giá tốt.',
    ),
  ];

  final List<Product> products = [
    Product(
      id: 'p1',
      shopId: 's1',
      name: 'Thịt bò thăn ngoại Úc',
      description: 'Thịt bò nhập khẩu tươi ngon, phù hợp làm steak.',
      category: 'Thịt bò',
      freshnessScore: 95,
      freshnessNote: 'Màu hồng tươi, đàn hồi tốt',
      price: 250000,
      tags: ['Tươi sống', 'Nhập khẩu'],
      status: 'Published',
    ),
    Product(
      id: 'p2',
      shopId: 's1',
      name: 'Thịt heo ba chỉ',
      description: 'Thịt heo VietGAP, không chất tạo nạc.',
      category: 'Thịt heo',
      freshnessScore: 88,
      freshnessNote: 'Mỡ trắng, thịt dính chặt',
      price: 120000,
      tags: ['VietGAP'],
      status: 'Published',
    ),
    Product(
      id: 'p3',
      shopId: 's2',
      name: 'Ức gà phi lê',
      description: 'Phù hợp cho người ăn kiêng, tập gym.',
      category: 'Thịt gà',
      freshnessScore: 45,
      freshnessNote: 'Có dấu hiệu hơi khô bề mặt',
      price: 85000,
      tags: ['Ăn kiêng'],
      status: 'Draft',
    ),
  ];

  final Map<String, List<Review>> reviewsByShop = {
    's1': const [
      Review(
        id: 'r1',
        userName: 'Nguyễn Văn A',
        rating: 5,
        comment: 'Thịt rất tươi, quét mã và kết quả kiểm tra khá khớp.',
        date: '2026-05-28',
      ),
      Review(
        id: 'r2',
        userName: 'Trần Thị B',
        rating: 4,
        comment: 'Giao hàng nhanh, đóng gói cẩn thận.',
        date: '2026-05-23',
      ),
    ],
    's2': const [
      Review(
        id: 'r3',
        userName: 'Lê Văn C',
        rating: 4,
        comment: 'Ức gà sạch, hợp tập gym.',
        date: '2026-05-20',
      ),
    ],
  };

  final Map<String, List<PledgeHistoryItem>> pledgesByProduct = {
    'p1': const [
      PledgeHistoryItem(
        time: '2026-05-30 07:15',
        title: 'Người bán thêm ghi nhận mới',
        description: 'Điểm đánh giá 8.7/10 cho lô bò thăn Úc buổi sáng.',
        isVerified: true,
        hasProof: true,
        proofId: '9af3c21db77e',
      ),
      PledgeHistoryItem(
        time: '2026-05-29 06:50',
        title: 'Buyer kiểm chứng tại chỗ',
        description:
            'Khách quét mã tại sạp, kết quả gần với ghi nhận trước đó.',
        isVerified: true,
        hasProof: true,
        proofId: '12b877ef0ac4',
      ),
      PledgeHistoryItem(
        time: '2026-05-28 16:40',
        title: 'Cửa hàng cập nhật trạng thái',
        description: 'Phát hiện lệch điểm nhỏ so với ghi nhận trước đó.',
        isVerified: false,
        hasProof: false,
        proofId: '',
      ),
    ],
  };

  final List<Voucher> vouchers = [
    Voucher(
      id: 'v1',
      code: 'FRESH20',
      title: 'Giảm 20% cho đơn thịt tươi',
      shopId: 's1',
      discountValue: 20,
      isPercent: true,
      minSpend: 150000,
      expiresAt: DateTime(2026, 6, 30, 23, 59),
    ),
    Voucher(
      id: 'v2',
      code: 'QUAY50K',
      title: 'Giảm 50.000đ tại quầy',
      shopId: 's1',
      discountValue: 50000,
      isPercent: false,
      minSpend: 250000,
      expiresAt: DateTime(2026, 6, 15, 23, 59),
    ),
    Voucher(
      id: 'v3',
      code: 'EXPIRED10',
      title: 'Mã đã hết hạn',
      shopId: 's1',
      discountValue: 10,
      isPercent: true,
      minSpend: 100000,
      expiresAt: DateTime(2026, 5, 1),
    ),
    Voucher(
      id: 'v4',
      code: 'BAHUAN15',
      title: 'Giảm 15% tại Ba Huân Food',
      shopId: 's2',
      discountValue: 15,
      isPercent: true,
      minSpend: 100000,
      expiresAt: DateTime(2026, 6, 28, 23, 59),
    ),
  ];

  final List<UserVoucher> userVouchers = [
    UserVoucher(
      id: 'uv1',
      userEmail: 'demo@vngrocery.com',
      voucherId: 'v1',
    ),
    UserVoucher(
      id: 'uv2',
      userEmail: 'demo@vngrocery.com',
      voucherId: 'v2',
      used: true,
      usedAt: DateTime(2026, 6, 2, 10, 30),
    ),
    UserVoucher(
      id: 'uv3',
      userEmail: 'google.demo@vngrocery.com',
      voucherId: 'v4',
    ),
  ];

  /// Kết quả buyer-check gần nhất (mock).
  BuyerCheckResult lastBuyerCheck = const BuyerCheckResult(
    actualScore: 78,
    locationStatus: 'near',
    verdict: 'Gần với ghi nhận trước đó',
  );

  Shop shopById(String id) =>
      shops.firstWhere((s) => s.id == id, orElse: () => shops.first);

  Product productById(String id) =>
      products.firstWhere((p) => p.id == id, orElse: () => products.first);

  List<Product> productsOfShop(String shopId) =>
      products.where((p) => p.shopId == shopId).toList();

  List<Review> reviewsOf(String shopId) => reviewsByShop[shopId] ?? const [];

  List<PledgeHistoryItem> pledgesOf(String productId) =>
      pledgesByProduct[productId] ?? const [];

  Voucher voucherById(String id) => vouchers
      .firstWhere((voucher) => voucher.id == id, orElse: () => vouchers.first);

  List<UserVoucher> userVoucherWallet(String userEmail) => userVouchers
      .where((item) => item.userEmail.toLowerCase() == userEmail.toLowerCase())
      .toList();

  UserVoucher userVoucherById(String id) => userVouchers
      .firstWhere((item) => item.id == id, orElse: () => userVouchers.first);

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

  void useUserVoucher(String userVoucherId) {
    final item = userVoucherById(userVoucherId);
    if (item.used) return;
    item.used = true;
    item.usedAt = DateTime.now();
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
    if (!voucher.active) {
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
