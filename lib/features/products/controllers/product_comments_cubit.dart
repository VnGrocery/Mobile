import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';
import 'package:vngrocery/data/api/remote_data_source.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';

class ProductCommentsState {
  final ProductCommentThread thread;
  final bool loading;

  /// The section could not be read. Kept apart from "no comments yet": showing
  /// an empty list for an unreachable server would claim nobody has said
  /// anything, which is the one thing this app must not get wrong.
  final bool failed;

  /// A write or a withdrawal is in flight, so the button can stop taking taps.
  final bool submitting;

  const ProductCommentsState({
    this.thread = const ProductCommentThread(),
    this.loading = false,
    this.failed = false,
    this.submitting = false,
  });

  ProductCommentsState copyWith({
    ProductCommentThread? thread,
    bool? loading,
    bool? failed,
    bool? submitting,
  }) {
    return ProductCommentsState(
      thread: thread ?? this.thread,
      loading: loading ?? this.loading,
      failed: failed ?? this.failed,
      submitting: submitting ?? this.submitting,
    );
  }
}

class ProductCommentsCubit extends Cubit<ProductCommentsState>
    with CloseSafeEmit {
  final AppRepositories _repositories;
  final String shopId;
  final String productId;

  ProductCommentsCubit({
    required this.shopId,
    required this.productId,
    AppRepositories? repositories,
  }) : _repositories = repositories ?? AppRepositories.instance,
       super(const ProductCommentsState());

  RemoteDataSource? get _remote => _repositories.products.remote;

  Future<void> load() async {
    final remote = _remote;
    if (remote == null) {
      // Not a silent no-op: an unconfigured remote leaves the section
      // spinning, which claims the comments are still on their way.
      emit(state.copyWith(loading: false, failed: true));
      return;
    }
    emit(state.copyWith(loading: true, failed: false));
    try {
      final thread = await remote.productComments(shopId, productId);
      emit(state.copyWith(thread: thread, loading: false, failed: false));
    } catch (_) {
      emit(state.copyWith(loading: false, failed: true));
    }
  }

  /// Writes the reader's comment and reloads, so what comes back is the
  /// server's verdict - published, or waiting for the shop - rather than this
  /// app's guess at it.
  Future<void> submit(String body) async {
    final remote = _remote;
    if (remote == null) throw StateError('no remote data source');
    emit(state.copyWith(submitting: true));
    try {
      await remote.createProductComment(shopId, productId, body);
    } catch (_) {
      emit(state.copyWith(submitting: false));
      rethrow;
    }
    await load();
    emit(state.copyWith(submitting: false));
  }

  Future<void> withdraw(ProductComment comment, String reason) async {
    final remote = _remote;
    // Thrown rather than swallowed: the caller shows a failure snackbar, and
    // a write that never left the phone must not look like it landed.
    if (remote == null) throw StateError('no remote data source');
    emit(state.copyWith(submitting: true));
    try {
      await remote.deleteProductComment(
        shopId,
        comment.id,
        expectedVersion: comment.version,
        reason: reason,
      );
    } catch (_) {
      emit(state.copyWith(submitting: false));
      rethrow;
    }
    await load();
    emit(state.copyWith(submitting: false));
  }
}
