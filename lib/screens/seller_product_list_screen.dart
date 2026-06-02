import 'package:flutter/material.dart';

import '../data/models.dart';
import '../features/seller_products/seller_product_presenter.dart';
import '../features/seller_products/widgets/seller_product_components.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

class SellerProductListScreen extends StatefulWidget {
  final String? shopId;
  final double bottomContentInset;

  const SellerProductListScreen({
    super.key,
    required this.shopId,
    this.bottomContentInset = 0,
  });

  @override
  State<SellerProductListScreen> createState() =>
      _SellerProductListScreenState();
}

class _SellerProductListScreenState extends State<SellerProductListScreen> {
  String _state = SellerProductPresenter.states.first;

  @override
  Widget build(BuildContext context) {
    final shopId = widget.shopId;
    if (shopId == null || shopId.isEmpty) {
      return Scaffold(
        backgroundColor: context.palette.appBackground,
        appBar: AppBar(
          title: const Text(
            'Sản phẩm của tôi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Text('Tài khoản của bạn chưa có cửa hàng.'),
        ),
      );
    }

    final products = SellerProductPresenter.filteredProducts(
      shopId: shopId,
      state: _state,
    );

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Sản phẩm của tôi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: widget.bottomContentInset),
        child: FloatingActionButton(
          backgroundColor: AppColors.meatRed,
          foregroundColor: Colors.white,
          onPressed: () => _openCreateProduct(shopId),
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          SellerProductFilterBar(
            value: _state,
            onChanged: (state) => setState(() => _state = state),
          ),
          Expanded(
            child: products.isEmpty
                ? const SellerProductEmptyState()
                : SellerProductList(
                    products: products,
                    bottomContentInset: widget.bottomContentInset,
                    onMore: _showProductActions,
                    onOpenHistory: _openHistory,
                    onCreatePledge: _openCreatePledgeForProduct,
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateProduct(String shopId) async {
    await Navigator.pushNamed(
      context,
      Routes.sellerCreateProduct,
      arguments: shopId,
    );
    if (mounted) setState(() {});
  }

  void _openHistory(Product product) {
    SellerProductRoutes.openHistory(context, product);
  }

  Future<void> _openCreatePledgeForProduct(Product product) async {
    await Navigator.pushNamed(
      context,
      Routes.sellerCreatePledge,
      arguments: product.id,
    );
    if (mounted) setState(() {});
  }

  void _showProductActions(Product product) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SellerProductActionSheet(
        product: product,
        onOpenDetail: () {
          Navigator.pop(context);
          SellerProductRoutes.openDetail(context, product);
        },
        onOpenHistory: () {
          Navigator.pop(context);
          _openHistory(product);
        },
        onCreatePledge: () async {
          Navigator.pop(context);
          await _openCreatePledgeForProduct(product);
        },
      ),
    );
  }
}
