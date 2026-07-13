import 'package:vngrocery/data/mock_data.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'buyer_check_repository.dart';
import 'id_repository.dart';
import 'pledge_repository.dart';
import 'product_repository.dart';
import 'review_repository.dart';
import 'seller_repository.dart';
import 'shop_repository.dart';
import 'voucher_repository.dart';

class AppRepositories {
  AppRepositories._(MockDb db, [RemoteDataSource? remote])
    : shops = ShopRepository(db, remote),
      products = ProductRepository(db, remote),
      reviews = ReviewRepository(db, remote),
      pledges = PledgeRepository(db, remote),
      buyerChecks = BuyerCheckRepository(db),
      vouchers = VoucherRepository(db, remote),
      seller = SellerRepository(db),
      ids = IdRepository(db);

  static AppRepositories instance = AppRepositories._(MockDb.instance);

  static void configureRemote(RemoteDataSource remote) {
    MockDb.instance.shops.clear();
    MockDb.instance.products.clear();
    MockDb.instance.reviewsByShop.clear();
    MockDb.instance.pledgesByProduct.clear();
    MockDb.instance.vouchers.clear();
    MockDb.instance.userVouchers.clear();
    instance = AppRepositories._(MockDb.instance, remote);
  }

  final ShopRepository shops;
  final ProductRepository products;
  final ReviewRepository reviews;
  final PledgeRepository pledges;
  final BuyerCheckRepository buyerChecks;
  final VoucherRepository vouchers;
  final SellerRepository seller;
  final IdRepository ids;
}
