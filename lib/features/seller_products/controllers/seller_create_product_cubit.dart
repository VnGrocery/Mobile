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

  /// The listing being edited, or null when this is a new one. Editing keeps
  /// the id, the version and the status: the form changes what the product is,
  /// not where it stands in the shop.
  final Product? existing;

  SellerCreateProductCubit({
    required this.shopId,
    this.existing,
    AppRepositories? repositories,
  }) : _repositories = repositories ?? AppRepositories.instance,
       super(
         existing == null
             ? SellerCreateProductState.initial()
             : SellerCreateProductState(
                 category: existing.category,
                 imageSelected: existing.imageUrls.isNotEmpty,
               ),
       );

  bool get isEditing => existing != null;

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

  /// [changeReason] is required when editing. The server signs the edit with
  /// that sentence inside the envelope and prints it in the product's change
  /// log, so a shopper can see not just that the price moved but why.
  Future<Product> save({
    required String name,
    required String description,
    required String price,
    required String tags,
    required AppLocalizations l10n,
    String changeReason = '',
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

    final current = existing;
    final product = Product(
      // Editing keeps the id and the version: the version is what lets the
      // server reject an edit written against a copy someone else has moved on.
      id: current?.id ?? _repositories.ids.nextId(),
      version: current?.version ?? 0,
      shopId: shopId,
      name: name.trim(),
      description: description.trim(),
      category: state.category,
      freshnessScore: current?.freshnessScore ?? 8,
      freshnessNote:
          current?.freshnessNote ??
          SellerProductPresenter.freshnessNote(state.imageSelected, l10n),
      price: SellerProductPresenter.parsePrice(price),
      tags: SellerProductPresenter.parseTags(tags),
      // A photo that was not re-taken keeps the one already on the listing.
      imageUrls: imageUrls.isEmpty && photo == null
          ? (current?.imageUrls ?? const [])
          : imageUrls,
      // Draft products are invisible to buyers: the server only exposes
      // "active" and "published". Creating them as drafts meant a seller could
      // add a product and never see it in their shop. An edit leaves the
      // status where the seller put it.
      status: current?.status ?? 'published',
    );
    try {
      final savedProduct = await _repositories.products.saveRemote(
        product,
        create: current == null,
        changeReason: changeReason,
      );
      emit(
        state.copyWith(saving: false, saved: true, imageFailed: imageFailed),
      );
      return savedProduct;
    } catch (_) {
      // Without this the button span for ever and the screen still announced
      // success, so a product that never reached the server looked saved.
      emit(state.copyWith(saving: false, saved: false));
      rethrow;
    }
  }
}
