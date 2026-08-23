import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'seller_product_list_state.dart';

class SellerProductListCubit extends Cubit<SellerProductListState> with CloseSafeEmit {
  final AppRepositories _repositories;
  final String shopId;

  SellerProductListCubit({required this.shopId, AppRepositories? repositories})
    : _repositories = repositories ?? AppRepositories.instance,
      super(SellerProductListState.initial());

  Future<void> load() async {
    emit(state.copyWith(products: _filteredProducts(state.selectedState)));
    try {
      await _repositories.products.refreshShop(shopId, seller: true);
      emit(state.copyWith(products: _filteredProducts(state.selectedState)));
    } catch (_) {}
  }

  void setStateFilter(String value) {
    emit(
      SellerProductListState(
        selectedState: value,
        products: _filteredProducts(value),
      ),
    );
  }

  List<Product> _filteredProducts(String state) {
    final all = _repositories.products.all(shopId: shopId);
    if (state == SellerProductPresenter.allState) return all;
    // Case-insensitive: the server writes 'published', older cached rows and
    // the mock data carry 'Published'.
    return all
        .where((product) => product.status.toLowerCase() == state)
        .toList();
  }
}
