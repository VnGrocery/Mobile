import 'package:flutter_bloc/flutter_bloc.dart';

/// Drops states emitted after the bloc has been closed.
///
/// Every screen here loads over the network and can be popped while that load
/// is still in flight, at which point the awaited call comes back and emits
/// into a closed bloc — which throws "Cannot emit new states after calling
/// close". A few controllers guarded against it with a hand-written
/// `if (isClosed) return;` before each emit and the rest simply crashed, so
/// the guard lives here once instead.
mixin CloseSafeEmit<S> on BlocBase<S> {
  @override
  void emit(S state) {
    if (isClosed) return;
    super.emit(state);
  }
}
