import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/widgets/product_thumbnail.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_cubit.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_state.dart';
import 'package:vngrocery/features/seller_dashboard/widgets/seller_dashboard_components.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_empty_state.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/core/utils/currency_formatter.dart';

class PledgeTab extends StatefulWidget {
  final double bottomContentInset;

  const PledgeTab({super.key, this.bottomContentInset = 0});

  @override
  State<PledgeTab> createState() => _PledgeTabState();
}

class _PledgeTabState extends State<PledgeTab> {
  late final SellerDashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = SellerDashboardCubit()
      ..load(context.read<SessionCubit>().state.shopId);
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  /// Mở lịch sử ghi nhận của một sản phẩm.
  ///
  /// Trước đây màn hình tự chọn `products.first` mà không nói là của sản phẩm
  /// nào, nên người bán có nhiều mặt hàng đọc nhầm lịch sử của mặt hàng khác.
  /// Picks a product, then records against it.
  Future<void> _openPledge(List<Product> products) async {
    final product = await _pickProduct(products);
    if (product == null || !mounted) return;
    await Navigator.pushNamed(
      context,
      Routes.sellerCreatePledge,
      arguments: SellerProductArgs(product.id),
    );
    if (mounted) {
      _dashboardCubit.load(context.read<SessionCubit>().state.shopId);
    }
  }

  Future<void> _openHistory(List<Product> products) async {
    final product = await _pickProduct(products);
    if (product == null || !mounted) return;
    await Navigator.pushNamed(
      context,
      Routes.pledgeHistory,
      arguments: SellerProductArgs(product.id),
    );
  }

  /// The product to act on.
  ///
  /// One product needs no question. More than one used to be resolved as
  /// `products.first` without saying which, so a seller with several lines
  /// read the wrong product's history.
  Future<Product?> _pickProduct(List<Product> products) async {
    if (products.isEmpty) return null;
    if (products.length == 1) return products.first;
    return showModalBottomSheet<Product>(
      context: context,
      backgroundColor: context.palette.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _ProductPicker(products: products),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shopId = context.watch<SessionCubit>().state.shopId;

    return BlocProvider.value(
      value: _dashboardCubit,
      // The tab is kept alive behind an IndexedStack, so it loaded once and
      // never again: a seller who created their shop from the empty state came
      // back to "this account has no shop" over the shop they had just made.
      child: BlocListener<SessionCubit, SessionState>(
        listenWhen: (previous, current) => previous.shopId != current.shopId,
        listener: (context, session) => _dashboardCubit.load(session.shopId),
        child: BlocBuilder<SellerDashboardCubit, SellerDashboardState>(
          builder: (context, state) {
            final dashboard = state.dashboard;
            if (dashboard == null) {
              return Scaffold(
                backgroundColor: context.palette.appBackground,
                appBar: AppBar(title: Text(l10n.pledgeOverviewTitle)),
                body: _EmptyDashboard(
                  status: state.status,
                  onCreateShop: () => Navigator.pushNamed(
                    context,
                    Routes.sellerShop,
                    arguments: shopId == null ? null : SellerShopArgs(shopId),
                  ),
                  onRetry: () => _dashboardCubit.load(shopId),
                ),
              );
            }

            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(
                title: Text(
                  l10n.pledgeOverviewTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: RefreshIndicator(
                color: AppColors.primaryGreen,
                onRefresh: () => _dashboardCubit.load(shopId),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    16 + widget.bottomContentInset,
                  ),
                  children: [
                    SellerDashboardHeader(shopName: dashboard.shop.name),
                    const SizedBox(height: 18),
                    CreateSellerPledgeCard(
                      canCreatePledge: state.canCreatePledge,
                      // Straight to a product to record against. It used to open
                      // the product list, which is exactly where the "Sản phẩm"
                      // button below already goes.
                      onTap: () => _openPledge(dashboard.products),
                    ),
                    const SizedBox(height: 14),
                    SellerDashboardActions(
                      onOpenProducts: () => Navigator.pushNamed(
                        context,
                        Routes.sellerProducts,
                        arguments: shopId == null
                            ? null
                            : SellerShopArgs(shopId),
                      ),
                      // Không có sản phẩm thì không có lịch sử để mở: nút phải
                      // tắt hẳn thay vì bấm vào rồi im lặng.
                      onOpenHistory: dashboard.products.isEmpty
                          ? null
                          : () => _openHistory(dashboard.products),
                      disabledHistoryHint: dashboard.products.isEmpty
                          ? l10n.sellerHistoryNeedsProduct
                          : null,
                    ),
                    const SizedBox(height: 22),
                    // Bằng chứng đứng trước số liệu. Trước đây thẻ này nằm cuối
                    // trang, kẻ y hệt một chỉ số thường, nên thứ duy nhất chứng
                    // minh chuỗi ghi nhận còn nguyên vẹn lại là thứ khó thấy
                    // nhất trên màn hình.
                    SellerStatusCard(
                      dashboard: dashboard,
                      onOpenProof: dashboard.products.isEmpty
                          ? null
                          : () => _openHistory(dashboard.products),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.pledgeOverviewMetricsTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SellerMetricGrid(dashboard: dashboard),
                    const SizedBox(height: 22),
                    Text(
                      l10n.pledgeOverviewHint,
                      style: TextStyle(
                        color: context.palette.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// What the dashboard shows when there are no figures to show.
///
/// All three reasons used to render the same spinner, and two of them - having
/// no shop, and a request that failed - never stopped spinning, because
/// nothing further was ever going to arrive.
class _EmptyDashboard extends StatelessWidget {
  final SellerDashboardStatus status;
  final VoidCallback onCreateShop;
  final VoidCallback onRetry;

  const _EmptyDashboard({
    required this.status,
    required this.onCreateShop,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (status == SellerDashboardStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final noShop = status == SellerDashboardStatus.noShop;
    return SellerEmptyState(
      icon: noShop ? Icons.storefront_outlined : Icons.cloud_off,
      title: noShop
          ? l10n.sellerDashboardNoShopTitle
          : l10n.sellerDashboardFailedTitle,
      body: noShop
          ? l10n.sellerDashboardNoShopBody
          : l10n.sellerDashboardFailedBody,
      actionLabel: noShop
          ? l10n.sellerDashboardNoShopAction
          : l10n.homeRetryAction,
      onAction: noShop ? onCreateShop : onRetry,
    );
  }
}

/// Chọn sản phẩm để xem lịch sử, khi cửa hàng có nhiều hơn một mặt hàng.
class _ProductPicker extends StatelessWidget {
  final List<Product> products;

  const _ProductPicker({required this.products});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              l10n.sellerPickProductTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: ProductThumbnail(
                    imageUrls: product.imageUrls,
                    size: 44,
                  ),
                  title: Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    formatCurrencyVnd(product.price),
                    style: const TextStyle(color: AppColors.priceRed),
                  ),
                  onTap: () => Navigator.pop(context, product),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
