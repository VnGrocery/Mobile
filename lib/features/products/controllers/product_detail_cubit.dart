import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/repositories.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> with CloseSafeEmit {
  final AppRepositories _repositories;

  ProductDetailCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const ProductDetailState());

  Future<void> load(String productId) async {
    final cached = _repositories.products.byIdOrNull(productId);
    if (cached != null) emit(ProductDetailState(product: cached));
    if (cached == null) return;
    try {
      final fresh = await _repositories.products.fetch(
        cached.shopId,
        productId,
      );
      emit(state.copyWith(product: fresh));
    } catch (_) {}
    if (isClosed) return;
    await Future.wait([loadShop(), loadHistory(), loadProof()]);
  }

  /// Loads the shop so the page can name the seller.
  Future<void> loadShop() async {
    final product = state.product;
    if (product == null) return;
    try {
      // Awaited into a local first: `state.copyWith(shop: await ...)` reads
      // `state` before the await, so the three loaders running side by side
      // would each emit a copy of the state as it was when they started, and
      // whichever finished last would wipe the other two.
      final shop = await _repositories.shops.fetch(product.shopId);
      emit(state.copyWith(shop: shop));
    } catch (_) {
      // The product still renders without the seller's name.
    }
  }

  /// Loads the signed record of every change made to this product.
  Future<void> loadHistory() async {
    final product = state.product;
    final remote = _repositories.products.remote;
    if (product == null || remote == null) return;
    try {
      final history = await remote.productHistory(product.shopId, product.id);
      emit(state.copyWith(history: history));
    } catch (_) {
      // An unreachable log leaves the section hidden rather than showing an
      // empty history, which would read as "nothing ever changed".
    }
  }

  /// Loads the blockchain verdict for the product's newest pledge.
  ///
  /// Deliberately separate from [load]: the product must render whether or not
  /// the chain can be reached, and anchoring takes a few seconds, so the view
  /// can call this again to refresh a pending badge.
  Future<void> loadProof() async {
    final product = state.product;
    if (product == null || isClosed) return;

    emit(state.copyWith(loadingProof: true));
    try {
      final proof = await _repositories.pledges.latestProof(
        product.shopId,
        product.id,
      );
      // copyWith, not a fresh state: the shop and the history load alongside
      // this and must not be wiped by whichever finishes last.
      emit(state.copyWith(proof: proof, loadingProof: false));
    } catch (_) {
      emit(state.copyWith(loadingProof: false));
    }
  }
}
