import '../mock_data.dart';
import 'buyer_check_repository.dart';
import 'id_repository.dart';
import 'pledge_repository.dart';
import 'product_repository.dart';
import 'review_repository.dart';
import 'seller_repository.dart';
import 'shop_repository.dart';
import 'voucher_repository.dart';

class AppRepositories {
  AppRepositories._(MockDb db)
      : shops = ShopRepository(db),
        products = ProductRepository(db),
        reviews = ReviewRepository(db),
        pledges = PledgeRepository(db),
        buyerChecks = BuyerCheckRepository(db),
        vouchers = VoucherRepository(db),
        seller = SellerRepository(db),
        ids = IdRepository(db);

  static final AppRepositories instance = AppRepositories._(MockDb.instance);

  final ShopRepository shops;
  final ProductRepository products;
  final ReviewRepository reviews;
  final PledgeRepository pledges;
  final BuyerCheckRepository buyerChecks;
  final VoucherRepository vouchers;
  final SellerRepository seller;
  final IdRepository ids;
}
