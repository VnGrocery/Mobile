import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/repositories.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final AppRepositories _repositories;

  ProductDetailCubit({AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(const ProductDetailState());

  Future<void> load(String productId) async {
    final cached = _repositories.products.byIdOrNull(productId);
    if (cached != null) emit(ProductDetailState(product: cached));
    if (cached == null) return;
    try {
      emit(
        state.copyWith(
          product: await _repositories.products.fetch(cached.shopId, productId),
        ),
      );
    } catch (_) {}
    if (isClosed) return;
    await loadProof();
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
      if (isClosed) return;
      emit(ProductDetailState(product: state.product, proof: proof));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(loadingProof: false));
    }
  }
}
