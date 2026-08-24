import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/utils/format.dart';
import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/widgets/trust_score_card.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/stores/controllers/store_detail_cubit.dart';
import 'package:vngrocery/features/vouchers/controllers/shop_vouchers_cubit.dart';
import 'package:vngrocery/features/vouchers/widgets/shop_voucher_section.dart';
import 'package:vngrocery/features/stores/controllers/store_detail_state.dart';
import 'package:vngrocery/features/stores/widgets/store_detail_components.dart';
import 'package:vngrocery/features/engagement/controllers/engagement_cubit.dart';
import 'package:vngrocery/features/engagement/widgets/follow_shop_button.dart';
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
  late final ShopVouchersCubit _vouchersCubit;
  late final EngagementCubit _engagementCubit;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _storeCubit = StoreDetailCubit()..load(widget.shopId);
    _vouchersCubit = ShopVouchersCubit(shopId: widget.shopId)..load();
    _engagementCubit = EngagementCubit(
      targetType: 'shop',
      targetId: widget.shopId,
    )..load();
  }

  @override
  void dispose() {
    _engagementCubit.close();
    _vouchersCubit.close();
    _storeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _storeCubit),
        BlocProvider.value(value: _vouchersCubit),
        BlocProvider.value(value: _engagementCubit),
      ],
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
                // Directly under the header: following is the one thing a
                // reader can do about this shop without scrolling.
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: FollowShopButton(),
                ),
                if (shop.trustSummary != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: TrustScoreCard(summary: shop.trustSummary!),
                  ),
                // Above the catalogue: an offer is a reason to keep reading,
                // and it is the one thing on this page with a deadline on it.
                const ShopVoucherSection(),
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
          l10n.storeShareSummary(formatRating(shop.rating), shop.reviewCount),
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
