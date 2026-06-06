import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
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
      child: BlocBuilder<SellerDashboardCubit, SellerDashboardState>(
        builder: (context, state) {
          final dashboard = state.dashboard;
          if (dashboard == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: Text(l10n.pledgeOverviewTitle)),
              body: const Center(child: CircularProgressIndicator()),
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
