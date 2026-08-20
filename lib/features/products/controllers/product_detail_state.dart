import 'package:vngrocery/data/models.dart';

class ProductDetailState {
  final Product? product;

  /// Blockchain verdict for the product's newest pledge. Null while it is being
  /// loaded, or when the product has no pledge to prove.
  final PledgeProof? proof;

  /// True while the proof is being (re)fetched, so the view can show progress
  /// without blanking the badge it already has.
  final bool loadingProof;

  const ProductDetailState({
    this.product,
    this.proof,
    this.loadingProof = false,
  });

  bool get hasProduct => product != null;
  bool get hasProof => proof != null;

  ProductDetailState copyWith({
    Product? product,
    PledgeProof? proof,
    bool? loadingProof,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      proof: proof ?? this.proof,
      loadingProof: loadingProof ?? this.loadingProof,
    );
  }
}
