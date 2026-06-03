import '../../../data/models.dart';
import '../seller_product_presenter.dart';

class SellerProductListState {
  final String selectedState;
  final List<Product> products;

  const SellerProductListState({
    required this.selectedState,
    this.products = const [],
  });

  factory SellerProductListState.initial() {
    return SellerProductListState(
      selectedState: SellerProductPresenter.states.first,
    );
  }

  SellerProductListState copyWith({
    String? selectedState,
    List<Product>? products,
  }) {
    return SellerProductListState(
      selectedState: selectedState ?? this.selectedState,
      products: products ?? this.products,
    );
  }
}
