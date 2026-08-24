import 'voucher.dart';

/// A live offer, ready to advertise, with the stall it belongs to.
///
/// The shop name travels with it because a discount at an unnamed stall is not
/// something a reader can act on. The server has already dropped offers that
/// have expired, been paused, or lost their shop, so anything here is
/// redeemable today.
class FeaturedVoucher {
  final Voucher voucher;
  final String shopName;

  const FeaturedVoucher({required this.voucher, required this.shopName});

  factory FeaturedVoucher.fromJson(Map<String, Object?> json) =>
      FeaturedVoucher(
        voucher: Voucher.fromJson(json),
        shopName: json['shopName']?.toString() ?? '',
      );
}
