import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/pledge_history/controllers/pledge_history_cubit.dart';

void main() {
  test('PledgeHistoryCubit loads product pledge history', () {
    final productId = AppRepositories.instance.products.all().first.id;
    final cubit = PledgeHistoryCubit();

    cubit.load(productId);

    expect(cubit.state.history, isNotEmpty);
    expect(cubit.state.isEmpty, isFalse);

    cubit.close();
  });
}
