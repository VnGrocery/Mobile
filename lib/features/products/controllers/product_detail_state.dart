import '../../../data/models.dart';

class ProductDetailState {
  final Product? product;

  const ProductDetailState({this.product});

  bool get hasProduct => product != null;
}
