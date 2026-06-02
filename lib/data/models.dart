/// Model dữ liệu port từ data/model/MockData.kt (bản Android VnGrocery).

class Shop {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String description;
  final String? logoUrl;

  const Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.logoUrl,
  });
}

class Product {
  final String id;
  final String shopId;
  String name;
  String description;
  String category;
  int freshnessScore; // thang 0-100
  String freshnessNote;
  int price; // VNĐ
  List<String> tags;
  String status; // "Published" / "Draft" / "Archived"

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.category,
    required this.freshnessScore,
    required this.freshnessNote,
    required this.price,
    required this.tags,
    required this.status,
  });
}

class Review {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final String date; // ISO yyyy-MM-dd

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class PledgeHistoryItem {
  final String time;
  final String title;
  final String description;
  final bool isVerified;
  final bool hasProof;
  final String proofId;

  const PledgeHistoryItem({
    required this.time,
    required this.title,
    required this.description,
    required this.isVerified,
    this.hasProof = false,
    this.proofId = '',
  });
}

class BuyerCheckResult {
  final int actualScore;
  final String locationStatus; // "near" / khác
  final String verdict;

  const BuyerCheckResult({
    required this.actualScore,
    required this.locationStatus,
    required this.verdict,
  });
}

class Voucher {
  final String id;
  final String code;
  final String title;
  final String shopId;
  final int discountValue;
  final bool isPercent;
  final int minSpend;
  final DateTime expiresAt;
  final bool active;

  const Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.shopId,
    required this.discountValue,
    required this.isPercent,
    required this.minSpend,
    required this.expiresAt,
    this.active = true,
  });
}

class UserVoucher {
  final String id;
  final String userEmail;
  final String voucherId;
  bool used;
  DateTime? usedAt;

  UserVoucher({
    required this.id,
    required this.userEmail,
    required this.voucherId,
    this.used = false,
    this.usedAt,
  });
}

class VoucherCheckResult {
  final Voucher? voucher;
  final bool valid;
  final String message;
  final int discountAmount;
  final int finalPrice;

  const VoucherCheckResult({
    required this.voucher,
    required this.valid,
    required this.message,
    required this.discountAmount,
    required this.finalPrice,
  });
}
