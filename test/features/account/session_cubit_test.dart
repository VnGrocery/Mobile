import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/app_data_config.dart';
import 'package:vngrocery/data/session.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';

void main() {
  tearDown(() {
    SessionManager.instance.logout();
  });

  test('SessionCubit logs in user mode by default', () {
    final cubit = SessionCubit();

    cubit.login(email: 'buyer@example.com', displayName: 'Buyer Demo');

    expect(cubit.state.isLoggedIn, isTrue);
    expect(cubit.state.email, 'buyer@example.com');
    expect(cubit.state.displayName, 'Buyer Demo');
    expect(cubit.state.role, 'user');
    expect(cubit.state.shopId, isNull);

    cubit.close();
  });

  test('SessionCubit switches seller mode and assigns demo shop', () {
    final cubit = SessionCubit();
    cubit.login(email: 'seller@example.com');

    cubit.setRole('seller');

    expect(cubit.state.isSeller, isTrue);
    expect(cubit.state.shopId, AppDataConfig.demoShopId);

    cubit.close();
  });

  test('SessionCubit updates shop id through manager API', () {
    final cubit = SessionCubit();
    cubit.login(email: 'seller@example.com', role: 'seller');

    cubit.setShopId('s2');

    expect(cubit.state.shopId, 's2');

    cubit.close();
  });

  test('SessionCubit clears shop id when switching back to buyer mode', () {
    final cubit = SessionCubit();
    cubit.login(email: 'seller@example.com', role: 'seller');

    cubit.setRole('user');

    expect(cubit.state.isSeller, isFalse);
    expect(cubit.state.shopId, isNull);

    cubit.close();
  });

  test('SessionCubit logout clears session state', () {
    final cubit = SessionCubit();
    cubit.login(email: 'buyer@example.com');

    cubit.logout();

    expect(cubit.state.isLoggedIn, isFalse);
    expect(cubit.state.email, isEmpty);
    expect(cubit.state.role, 'user');

    cubit.close();
  });
}
