import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'seller_create_product_state.dart';

class SellerCreateProductCubit extends Cubit<SellerCreateProductState> {
  final AppRepositories _repositories;
  final String shopId;
  final Duration saveDelay;

  SellerCreateProductCubit({
    required this.shopId,
    this.saveDelay = const Duration(milliseconds: 900),
    AppRepositories? repositories,
  })  : _repositories = repositories ?? AppRepositories.instance,
        super(SellerCreateProductState.initial());

  void setCategory(String category) {
    emit(state.copyWith(category: category, saved: false));
  }

  void toggleImage() {
    emit(
      state.copyWith(
        imageSelected: !state.imageSelected,
        saved: false,
      ),
    );
  }

  Future<Product> save({
    required String name,
    required String description,
    required String price,
    required String tags,
  }) async {
    emit(state.copyWith(saving: true, saved: false));
    await Future<void>.delayed(saveDelay);
    final product = Product(
      id: _repositories.ids.nextId(),
      shopId: shopId,
      name: name.trim(),
      description: description.trim(),
      category: state.category,
      freshnessScore: 80,
      freshnessNote: SellerProductPresenter.freshnessNote(
        state.imageSelected,
      ),
      price: SellerProductPresenter.parsePrice(price),
      tags: SellerProductPresenter.parseTags(tags),
      status: 'Draft',
    );
    _repositories.products.add(product);
    emit(state.copyWith(saving: false, saved: true));
    return product;
  }
}
