import 'package:vngrocery/data/models.dart';

class ProductDetailState {
  final Product? product;

  /// Blockchain verdict for the product's newest pledge. Null while it is being
  /// loaded, or when the product has no pledge to prove.
  final PledgeProof? proof;

  /// True while the proof is being (re)fetched, so the view can show progress
  /// without blanking the badge it already has.
  final bool loadingProof;

  /// The signed log could not be reached. Distinct from "this product has no
  /// history": hiding both looked identical, so a network failure read as
  /// "nothing ever changed" - the one claim this app must never make by
  /// accident.
  final bool historyFailed;

  /// The shop selling it, so the page can name the seller rather than showing a
  /// product that belongs to nobody.
  final Shop? shop;

  /// Signed, hash-chained record of every change to this product. Null while it
  /// loads or when the server could not produce one.
  final ProductHistory? history;

  const ProductDetailState({
    this.product,
    this.proof,
    this.loadingProof = false,
    this.historyFailed = false,
    this.shop,
    this.history,
  });

  bool get hasProduct => product != null;
  bool get hasProof => proof != null;

  /// True once there is a recorded history worth showing.
  bool get hasHistory => history != null && !history!.isEmpty;

  ProductDetailState copyWith({
    Product? product,
    PledgeProof? proof,
    bool? loadingProof,
    bool? historyFailed,
    Shop? shop,
    ProductHistory? history,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      proof: proof ?? this.proof,
      loadingProof: loadingProof ?? this.loadingProof,
      historyFailed: historyFailed ?? this.historyFailed,
      shop: shop ?? this.shop,
      history: history ?? this.history,
    );
  }
}
