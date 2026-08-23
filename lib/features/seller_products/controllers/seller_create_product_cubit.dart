import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/bloc/close_safe_emit.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/repositories.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'seller_create_product_state.dart';

class SellerCreateProductCubit extends Cubit<SellerCreateProductState>
    with CloseSafeEmit {
  final AppRepositories _repositories;
  final String shopId;

  SellerCreateProductCubit({
    required this.shopId,
    AppRepositories? repositories,
  }) : _repositories = repositories ?? AppRepositories.instance,
       super(SellerCreateProductState.initial());

  void setCategory(String category) {
    emit(state.copyWith(category: category, saved: false));
  }

  /// Photo the seller took for the listing. This used to be a bare bool with
  /// no picture behind it, so products were always created without an image.
  Uint8List? _image;

  bool get hasImage => _image != null;

  void attachImage(Uint8List image) {
    _image = image;
    emit(state.copyWith(imageSelected: true, saved: false));
  }

  void removeImage() {
    _image = null;
    emit(state.copyWith(imageSelected: false, saved: false));
  }

  Future<Product> save({
    required String name,
    required String description,
    required String price,
    required String tags,
    required AppLocalizations l10n,
  }) async {
    emit(state.copyWith(saving: true, saved: false));

    final imageUrls = <String>[];
    final photo = _image;
    final remote = _repositories.products.remote;
    var imageFailed = false;
    if (photo != null && remote != null) {
      try {
        final url = await remote.uploadImage(photo);
        if (url != null) {
          imageUrls.add(url);
        } else {
          imageFailed = true;
        }
      } catch (_) {
        // A photo that will not upload must not cost the seller the whole
        // listing - but they are told it went without one.
        imageFailed = true;
      }
    }

    final product = Product(
      id: _repositories.ids.nextId(),
      shopId: shopId,
      name: name.trim(),
      description: description.trim(),
      category: state.category,
      freshnessScore: 8,
      freshnessNote: SellerProductPresenter.freshnessNote(
        state.imageSelected,
        l10n,
      ),
      price: SellerProductPresenter.parsePrice(price),
      tags: SellerProductPresenter.parseTags(tags),
      imageUrls: imageUrls,
      // Draft products are invisible to buyers: the server only exposes
      // "active" and "published". Creating them as drafts meant a seller could
      // add a product and never see it in their shop.
      status: 'published',
    );
    try {
      final savedProduct = await _repositories.products.saveRemote(product);
      emit(state.copyWith(saving: false, saved: true, imageFailed: imageFailed));
      return savedProduct;
    } catch (_) {
      // Without this the button span for ever and the screen still announced
      // success, so a product that never reached the server looked saved.
      emit(state.copyWith(saving: false, saved: false));
      rethrow;
    }
  }
}
