import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_pledges/controllers/seller_pledge_cubit.dart';

void main() {
  test('SellerPledgeCubit advances capture flow to evaluate step', () async {
    final cubit = SellerPledgeCubit(
      productId: 'p1',
      delayService: const NoopAppDelayService(),
    );

    await cubit.capture();

    expect(cubit.state.step, 2);
    expect(cubit.state.analyzing, isFalse);

    cubit.close();
  });

  test('SellerPledgeCubit commits pledge history item', () async {
    final productId = AppRepositories.instance.products.all().first.id;
    final before = AppRepositories.instance.pledges.ofProduct(productId).length;
    final cubit = SellerPledgeCubit(
      productId: productId,
      delayService: const NoopAppDelayService(),
    );

    cubit.setCategory('Khác');
    await cubit.commit('9.1');

    final after = AppRepositories.instance.pledges.ofProduct(productId);
    expect(after.length, before + 1);
    expect(after.first.description, contains('9.1/10'));
    expect(after.first.description, contains('Khác'));
    expect(cubit.state.committed, isTrue);
    expect(cubit.state.committing, isFalse);

    cubit.close();
  });
}
