import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/ui/app_feedback.dart';
import '../data/models.dart';
import '../features/stores/store_presenter.dart';
import '../features/stores/widgets/store_detail_components.dart';
import '../routes/app_routes.dart';
import '../theme/app_palette.dart';

class StoreDetailScreen extends StatefulWidget {
  final String shopId;

  const StoreDetailScreen({super.key, required this.shopId});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final shop = StorePresenter.shop(widget.shopId);
    final products = StorePresenter.products(widget.shopId);
    final reviews = StorePresenter.reviews(widget.shopId);

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text('Chi tiết cửa hàng'),
        actions: [
          IconButton(
            onPressed: () => _shareShop(shop),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          StoreHeader(shop: shop),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sản phẩm mới kiểm tra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LatestReceiptCard(
                  onOpenReceipt: () => _openLatestReceipt(products),
                ),
              ],
            ),
          ),
          StoreDetailTabs(
            value: _tab,
            onChanged: (index) => setState(() => _tab = index),
          ),
          if (_tab == 0)
            StoreProductList(products: products)
          else
            StoreReviewList(shopId: widget.shopId, reviews: reviews),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _shareShop(Shop shop) {
    Clipboard.setData(ClipboardData(text: StorePresenter.shareText(shop)));
    AppFeedback.showSnackBar(context, 'Đã sao chép thông tin cửa hàng');
  }

  void _openLatestReceipt(List<Product> products) {
    if (products.isEmpty) {
      AppFeedback.showSnackBar(
        context,
        'Cửa hàng chưa có biên lai sản phẩm',
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.pledgeHistory,
      arguments: products.first.id,
    );
  }
}
