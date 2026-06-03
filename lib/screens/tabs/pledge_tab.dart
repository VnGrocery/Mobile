import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/account/controllers/session_cubit.dart';
import '../../features/seller_dashboard/controllers/seller_dashboard_cubit.dart';
import '../../features/seller_dashboard/controllers/seller_dashboard_state.dart';
import '../../features/seller_dashboard/widgets/seller_dashboard_components.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';

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
    final shopId = context.watch<SessionCubit>().state.shopId;

    return BlocProvider.value(
      value: _dashboardCubit,
      child: BlocBuilder<SellerDashboardCubit, SellerDashboardState>(
        builder: (context, state) {
          final dashboard = state.dashboard;
          if (dashboard == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: const Text('Tổng quan bán hàng')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: const Text(
                'Tổng quan bán hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
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
                    arguments: shopId,
                  ),
                ),
                const SizedBox(height: 14),
                SellerDashboardActions(
                  onOpenProducts: () => Navigator.pushNamed(
                    context,
                    Routes.sellerProducts,
                    arguments: shopId,
                  ),
                  onOpenHistory: () {
                    final firstProduct = dashboard.products.isEmpty
                        ? null
                        : dashboard.products.first;
                    if (firstProduct == null) return;
                    Navigator.pushNamed(
                      context,
                      Routes.pledgeHistory,
                      arguments: firstProduct.id,
                    );
                  },
                ),
                const SizedBox(height: 22),
                const Text(
                  'Chỉ số cửa hàng',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SellerMetricGrid(dashboard: dashboard),
                const SizedBox(height: 22),
                SellerStatusCard(dashboard: dashboard),
                const SizedBox(height: 22),
                const Text(
                  'Chụp ảnh trong điều kiện đủ sáng để điểm đánh giá ổn định. Mỗi ghi nhận demo sẽ lưu tạm cho đến khi gắn dữ liệu thật.',
                  style: TextStyle(
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
