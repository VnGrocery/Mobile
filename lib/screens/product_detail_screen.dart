import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/core/widgets/trust_badge.dart';
import 'package:vngrocery/features/cart/controllers/cart_bloc.dart';
import 'package:vngrocery/features/cart/controllers/cart_event.dart';
import 'package:vngrocery/features/products/controllers/product_detail_cubit.dart';
import 'package:vngrocery/features/products/controllers/product_detail_state.dart';
import 'package:vngrocery/features/products/widgets/market_price_chart.dart';
import 'package:vngrocery/features/products/widgets/price_history_chart.dart';
import 'package:vngrocery/features/products/widgets/product_change_log.dart';
import 'package:vngrocery/features/products/widgets/product_detail_components.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/products/controllers/product_comments_cubit.dart';
import 'package:vngrocery/features/products/widgets/product_comments.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ProductDetailScreen extends StatefulWidget {
  final String shopId;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.shopId,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailCubit _productCubit;

  /// Created once the product is known, because the comment endpoints are
  /// addressed by shop as well as by product.
  ProductCommentsCubit? _commentsCubit;

  @override
  void initState() {
    super.initState();
    _productCubit = ProductDetailCubit()..load(widget.productId);
  }

  @override
  void dispose() {
    _commentsCubit?.close();
    _productCubit.close();
    super.dispose();
  }

  void _ensureComments(Product product) {
    if (_commentsCubit != null) return;
    _commentsCubit = ProductCommentsCubit(
      shopId: product.shopId,
      productId: product.id,
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _productCubit,
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          final product = state.product;
          if (product == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: Text(l10n.productDetailTitle)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(title: Text(l10n.productDetailTitle)),
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                ProductHeroImage(imageUrls: product.imageUrls),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductTitleBlock(product: product, shop: state.shop),
                      const SizedBox(height: 12),
                      // Always something. Rendering nothing when the proof was
                      // missing meant a buyer - and an examiner - could not
                      // tell a chain still being anchored from a product with
                      // no record at all, on the screen built to show exactly
                      // that.
                      if (state.hasProof)
                        TrustBadge(
                          proof: state.proof!,
                          // The certificate screen is otherwise unreachable for
                          // buyers: pledge history is a seller-only route.
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.blockchainProof,
                            arguments: BlockchainProofArgs(
                              shopId: product.shopId,
                              pledgeId: state.proof!.pledgeId,
                            ),
                          ),
                        )
                      else
                        TrustBadge.absent(loading: state.loadingProof),
                      const SizedBox(height: 16),
                      // The reason a buyer opened this screen while standing at
                      // the stall: check the goods against the record. It leads,
                      // and the cart follows it as the secondary action.
                      const ProductCheckAction(),
                      const SizedBox(height: 12),
                      SizedBox(
                        // Minimum, not fixed: a fixed 52 clipped the label at
                        // the system font scales this app has to survive.
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<CartBloc>().add(
                              CartAddRequested(product: product),
                            );
                            AppFeedback.showSnackBar(
                              context,
                              l10n.productDetailAddedToCart(product.name),
                              icon: Icons.add_shopping_cart_rounded,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          icon: const Icon(Icons.add_shopping_cart),
                          label: Text(l10n.productDetailAddToCart),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // What other buyers found when they did the same check.
                      // It sits above the seller's own claims on purpose.
                      Builder(
                        builder: (context) {
                          _ensureComments(product);
                          return BlocProvider.value(
                            value: _commentsCubit!,
                            child: const ProductComments(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Then what the shop says and what the record shows:
                      // pledge score, prices, and the signed change log.
                      ProductScoreCard(score: product.freshnessScore),
                      if (state.historyFailed && !state.hasHistory) ...[
                        const SizedBox(height: 16),
                        ProductHistoryUnavailable(
                          onRetry: () => _productCubit.loadHistory(),
                        ),
                      ],
                      if (state.hasHistory) ...[
                        const SizedBox(height: 16),
                        PriceHistoryChart(history: state.history!),
                        if (state.history!.market case final market?) ...[
                          const SizedBox(height: 12),
                          MarketPriceChart(
                            market: market,
                            shopHistory: state.history!.priceHistory,
                            shopPrice: product.price.toDouble(),
                            windowDays: state.history!.windowDays,
                          ),
                        ],
                        const SizedBox(height: 12),
                        ProductChangeLog(history: state.history!),
                      ],
                      const SizedBox(height: 24),
                      ProductCounterInfo(product: product),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
