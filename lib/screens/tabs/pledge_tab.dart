import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_cubit.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_state.dart';
import 'package:vngrocery/features/seller_dashboard/widgets/seller_dashboard_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

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
              body: ListView(
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
                    onTap: () => Navigator.pushNamed(
                      context,
                      Routes.sellerProducts,
                      arguments: shopId == null ? null : SellerShopArgs(shopId),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SellerDashboardActions(
                    onOpenProducts: () => Navigator.pushNamed(
                      context,
                      Routes.sellerProducts,
                      arguments: shopId == null ? null : SellerShopArgs(shopId),
                    ),
                    onOpenHistory: () {
                      final firstProduct = dashboard.products.isEmpty
                          ? null
                          : dashboard.products.first;
                      if (firstProduct == null) return;
                      Navigator.pushNamed(
                        context,
                        Routes.pledgeHistory,
                        arguments: SellerProductArgs(firstProduct.id),
                      );
                    },
                  ),
                  const SizedBox(height: 22),
                  Text(
                    l10n.pledgeOverviewMetricsTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SellerMetricGrid(dashboard: dashboard),
                  const SizedBox(height: 22),
                  SellerStatusCard(dashboard: dashboard),
                  const SizedBox(height: 22),
                  Text(
                    l10n.pledgeOverviewHint,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              noShop ? Icons.storefront_outlined : Icons.cloud_off,
              size: 44,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              noShop
                  ? l10n.sellerDashboardNoShopTitle
                  : l10n.sellerDashboardFailedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              noShop
                  ? l10n.sellerDashboardNoShopBody
                  : l10n.sellerDashboardFailedBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: noShop ? onCreateShop : onRetry,
              child: Text(
                noShop
                    ? l10n.sellerDashboardNoShopAction
                    : l10n.homeRetryAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
