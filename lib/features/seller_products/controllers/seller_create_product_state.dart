import '../seller_product_presenter.dart';

class SellerCreateProductState {
  final String category;
  final bool imageSelected;
  final bool saving;
  final bool saved;

  const SellerCreateProductState({
    required this.category,
    this.imageSelected = false,
    this.saving = false,
    this.saved = false,
  });

  factory SellerCreateProductState.initial() {
    return SellerCreateProductState(
      category: SellerProductPresenter.categories.first,
    );
  }

  SellerCreateProductState copyWith({
    String? category,
    bool? imageSelected,
    bool? saving,
    bool? saved,
  }) {
    return SellerCreateProductState(
      category: category ?? this.category,
      imageSelected: imageSelected ?? this.imageSelected,
      saving: saving ?? this.saving,
      saved: saved ?? this.saved,
    );
  }
}
