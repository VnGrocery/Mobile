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
        ProductDetailState(
          product: await _repositories.products.fetch(cached.shopId, productId),
        ),
      );
    } catch (_) {}
  }
}
