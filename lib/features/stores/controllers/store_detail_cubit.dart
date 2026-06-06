import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'store_detail_state.dart';

class StoreDetailCubit extends Cubit<StoreDetailState> {
  final AppRepositories _repositories;

  StoreDetailCubit({AppRepositories? repositories})
      : _repositories = repositories ?? AppRepositories.instance,
        super(const StoreDetailState());

  void load(String shopId) {
    emit(
      StoreDetailState(
        shop: _repositories.shops.byId(shopId),
        products: _repositories.products.all(shopId: shopId),
        reviews: _repositories.reviews.ofShop(shopId),
      ),
    );
  }

  String shareText(Shop shop, String summary) {
    return '${shop.name}\n${shop.address}\n$summary';
  }
}
