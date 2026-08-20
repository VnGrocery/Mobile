import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/core/bloc/close_safe_emit.dart';

class _Counter extends Cubit<int> with CloseSafeEmit {
  _Counter() : super(0);

  void bump() => emit(state + 1);
}

void main() {
  test('emits normally while open', () {
    final cubit = _Counter()..bump();

    expect(cubit.state, 1);
    cubit.close();
  });

  test('a state emitted after close is dropped instead of throwing', () async {
    final cubit = _Counter();
    await cubit.close();

    // Without the mixin this throws "Cannot emit new states after calling
    // close", which is what a screen popped mid-load used to do.
    expect(cubit.bump, returnsNormally);
    expect(cubit.state, 0);
  });
}
