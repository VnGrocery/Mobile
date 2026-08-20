import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/widgets/trust_score_card.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/stores/controllers/store_detail_cubit.dart';
import 'package:vngrocery/features/stores/controllers/store_detail_state.dart';
import 'package:vngrocery/features/stores/widgets/store_detail_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

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
          final l10n = AppLocalizations.of(context);
          final shop = state.shop;
          if (shop == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: Text(l10n.storeDetailTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            key: ValueKey('store_detail.${shop.id}'),
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: Text(l10n.storeDetailTitle),
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
                if (shop.trustSummary != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: TrustScoreCard(summary: shop.trustSummary!),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.storeDetailRecentCheckedProducts,
                        style: const TextStyle(
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
                    shopId: widget.shopId,
                    reviews: state.reviews,
                    canWriteReview: !context
                        .watch<SessionCubit>()
                        .state
                        .isSeller,
                  ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  void _shareShop(Shop shop) {
    final l10n = AppLocalizations.of(context);
    Clipboard.setData(
      ClipboardData(
        text: _storeCubit.shareText(
          shop,
          l10n.storeShareSummary(shop.rating.toString(), shop.reviewCount),
        ),
      ),
    );
    AppFeedback.showSnackBar(context, l10n.storeDetailCopied);
  }

  void _openLatestReceipt(StoreDetailState state) {
    if (context.read<SessionCubit>().state.isSeller) {
      final latestProduct = state.latestProduct;
      if (latestProduct == null) {
        AppFeedback.showSnackBar(
          context,
          AppLocalizations.of(context).storeDetailNoReceipt,
        );
        return;
      }
      Navigator.pushNamed(
        context,
        Routes.pledgeHistory,
        arguments: SellerProductArgs(latestProduct.id),
      );
      return;
    }

    final latestProduct = state.latestProduct;
    if (latestProduct == null) {
      AppFeedback.showSnackBar(
        context,
        AppLocalizations.of(context).storeDetailNoReceipt,
      );
      return;
    }
    Navigator.pushNamed(
      context,
      Routes.productDetail,
      arguments: ProductDetailArgs(
        shopId: widget.shopId,
        productId: latestProduct.id,
      ),
    );
  }
}
