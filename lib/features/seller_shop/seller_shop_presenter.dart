class SellerShopPresenter {
  const SellerShopPresenter._();

  static const demoShopId = 's1';

  static String effectiveShopId(String? shopId) {
    return shopId ?? demoShopId;
  }
}
