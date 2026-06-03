import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/ui/app_feedback.dart';
import '../data/models.dart';
import '../features/stores/controllers/store_detail_cubit.dart';
import '../features/stores/controllers/store_detail_state.dart';
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
  late final StoreDetailCubit _storeCubit;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _storeCubit = StoreDetailCubit()..load(widget.shopId);
  }

  @override
  void dispose() {
    _storeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _storeCubit,
      child: BlocBuilder<StoreDetailCubit, StoreDetailState>(
        builder: (context, state) {
          final shop = state.shop;
          if (shop == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: const Text('Chi tiết cửa hàng')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LatestReceiptCard(
                        onOpenReceipt: () => _openLatestReceipt(state),
                      ),
                    ],
                  ),
                ),
                StoreDetailTabs(
                  value: _tab,
                  onChanged: (index) => setState(() => _tab = index),
                ),
                if (_tab == 0)
                  StoreProductList(products: state.products)
                else
                  StoreReviewList(
                      shopId: widget.shopId, reviews: state.reviews),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  void _shareShop(Shop shop) {
    Clipboard.setData(ClipboardData(text: _storeCubit.shareText(shop)));
    AppFeedback.showSnackBar(context, 'Đã sao chép thông tin cửa hàng');
  }

  void _openLatestReceipt(StoreDetailState state) {
    final latestProduct = state.latestProduct;
    if (latestProduct == null) {
      AppFeedback.showSnackBar(
        context,
        'Cửa hàng chưa có biên lai sản phẩm',
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.pledgeHistory,
      arguments: latestProduct.id,
    );
  }
}
