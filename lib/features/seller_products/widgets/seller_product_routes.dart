import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/routes/app_routes.dart';

class SellerProductRoutes {
  const SellerProductRoutes._();

  static void openDetail(BuildContext context, Product product) {
    Navigator.pushNamed(
      context,
      Routes.productDetail,
      arguments: ProductDetailArgs(
        shopId: product.shopId,
        productId: product.id,
      ),
    );
  }

  static void openHistory(BuildContext context, Product product) {
    Navigator.pushNamed(context, Routes.pledgeHistory,
        arguments: SellerProductArgs(product.id));
  }
}
