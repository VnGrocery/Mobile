import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/features/seller_dashboard/controllers/seller_dashboard_cubit.dart';

void main() {
  test('SellerDashboardCubit loads dashboard for seller shop', () {
    final cubit = SellerDashboardCubit();

    cubit.load(AppDataConfig.demoShopId);

    expect(cubit.state.hasDashboard, isTrue);
    expect(cubit.state.dashboard?.shop.id, AppDataConfig.demoShopId);
    expect(cubit.state.canCreatePledge, isTrue);

    cubit.close();
  });
}
