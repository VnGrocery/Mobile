import 'models.dart';

/// Kho dữ liệu giả (singleton) — nội dung port từ MockData.kt, bổ sung
/// thêm timeline cam kết & kết quả buyer-check để demo đầy đủ luồng.
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
      description: 'Uy tín làm nên thương hiệu.',
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
        comment: 'Thịt rất tươi, quét mã AI kết quả rất khớp.',
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
        title: 'Seller tạo cam kết mới',
        description: 'Cam kết chất lượng 8.7/10 cho lô bò thăn Úc buổi sáng.',
        isVerified: true,
        hasProof: true,
        proofId: '9af3c21db77e',
      ),
      PledgeHistoryItem(
        time: '2026-05-29 06:50',
        title: 'Buyer kiểm chứng tại chỗ',
        description: 'Khách quét mã tại sạp, kết quả khớp cam kết.',
        isVerified: true,
        hasProof: true,
        proofId: '12b877ef0ac4',
      ),
      PledgeHistoryItem(
        time: '2026-05-28 16:40',
        title: 'Cửa hàng cập nhật trạng thái',
        description: 'Phát hiện lệch điểm nhỏ so với cam kết, ghi nhận cảnh báo.',
        isVerified: false,
        hasProof: false,
        proofId: '',
      ),
    ],
  };

  /// Kết quả buyer-check gần nhất (mock).
  BuyerCheckResult lastBuyerCheck = const BuyerCheckResult(
    actualScore: 78,
    locationStatus: 'near',
    verdict: 'Tương đồng với cam kết',
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

  void addProduct(Product p) => products.add(p);

  void addPledge(String productId, PledgeHistoryItem e) {
    pledgesByProduct.putIfAbsent(productId, () => []).insert(0, e);
  }

  int _seq = 2000;
  String nextId() => 'g${_seq++}';
}
