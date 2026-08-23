import 'package:vngrocery/features/home/category_presenter.dart';

class SellerCreateProductState {
  final String category;
  final bool imageSelected;
  final bool saving;
  final bool saved;

  /// The listing saved, but its photo did not reach IPFS.
  final bool imageFailed;

  const SellerCreateProductState({
    required this.category,
    this.imageSelected = false,
    this.saving = false,
    this.saved = false,
    this.imageFailed = false,
  });

  factory SellerCreateProductState.initial() {
    return SellerCreateProductState(
      category: CategoryPresenter.selectable.first,
    );
  }

  SellerCreateProductState copyWith({
    String? category,
    bool? imageSelected,
    bool? saving,
    bool? saved,
    bool? imageFailed,
  }) {
    return SellerCreateProductState(
      category: category ?? this.category,
      imageSelected: imageSelected ?? this.imageSelected,
      saving: saving ?? this.saving,
      saved: saved ?? this.saved,
      imageFailed: imageFailed ?? this.imageFailed,
    );
  }
}
