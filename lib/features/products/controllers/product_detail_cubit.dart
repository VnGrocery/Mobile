import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final AppRepositories _repositories;

  ProductDetailCubit({AppRepositories? repositories})
      : _repositories = repositories ?? AppRepositories.instance,
        super(const ProductDetailState());

  void load(String productId) {
    emit(ProductDetailState(product: _repositories.products.byId(productId)));
  }
}
