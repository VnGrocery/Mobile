import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/home/controllers/home_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';

void main() {
  test('HomeCubit loads the shops and the catalogue behind them', () async {
    final cubit = HomeCubit();

    await cubit.load();

    expect(cubit.state.shops, isNotEmpty);
    expect(cubit.state.products, isNotEmpty);

    cubit.close();
  });

  test(
    'a finished load is marked ready so the tab stops showing a spinner',
    () async {
      final cubit = HomeCubit();

      expect(cubit.state.status, HomeStatus.loading);
      await cubit.load();

      expect(cubit.state.status, HomeStatus.ready);
      expect(cubit.state.isEmpty, isFalse);

      cubit.close();
    },
  );

  test('leaving the tab mid-load does not emit into a closed cubit', () async {
    final cubit = HomeCubit();

    final pending = cubit.load();
    await cubit.close();

    await expectLater(pending, completes);
  });
}
