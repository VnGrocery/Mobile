import 'package:flutter/material.dart';

import '../../../data/models.dart';
import '../../../routes/app_routes.dart';

class SellerProductRoutes {
  const SellerProductRoutes._();

  static void openDetail(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      Routes.productDetail,
      arguments: {'shopId': product.shopId, 'productId': product.id},
    );
  }

  static void openHistory(BuildContext context, Product product) {
    Navigator.pushNamed(context, Routes.pledgeHistory, arguments: product.id);
  }
}
