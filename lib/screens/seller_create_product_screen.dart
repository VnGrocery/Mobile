import 'dart:typed_data';
import 'package:vngrocery/screens/camera_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_shop_text_field.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_state.dart';
import 'package:vngrocery/features/seller_products/widgets/seller_create_product_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// One form for adding a listing and for editing one.
///
/// Editing pre-fills what is there and adds the mandatory reason: the change
/// is signed with that sentence inside it and appears in the product's own
/// change log, the same as every other edit to a signed record in this app.
class SellerCreateProductScreen extends StatefulWidget {
  final String shopId;

  /// Null to add a new listing.
  final Product? product;

  const SellerCreateProductScreen({
    super.key,
    required this.shopId,
    this.product,
  });

  @override
  State<SellerCreateProductScreen> createState() =>
      _SellerCreateProductScreenState();
}

class _SellerCreateProductScreenState extends State<SellerCreateProductScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();
  final _tags = TextEditingController();
  final _changeReason = TextEditingController();
  late final SellerCreateProductCubit _createCubit;

  bool get _editing => widget.product != null;

  bool get _canSave {
    if (_name.text.trim().isEmpty || _price.text.trim().isEmpty) return false;
    // No unexplained edits to a signed record. Creating one needs no reason:
    // there is nothing yet to explain a change to.
    if (_editing && _changeReason.text.trim().length < 5) return false;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _createCubit = SellerCreateProductCubit(
      shopId: widget.shopId,
      existing: widget.product,
    );
    final product = widget.product;
    if (product != null) {
      _name.text = product.name;
      _price.text = product.price.toString();
      _desc.text = product.description;
      _tags.text = product.tags.join(', ');
    }
  }

  @override
  void dispose() {
    _createCubit.close();
    _name.dispose();
    _price.dispose();
    _desc.dispose();
    _tags.dispose();
    _changeReason.dispose();
    super.dispose();
  }

  /// Takes the listing photo. The button used to flip a flag with no picture
  /// behind it, so every product was created without an image.
  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);
    if (_createCubit.hasImage) {
      _createCubit.removeImage();
      if (!mounted) return;
      AppFeedback.showSnackBar(context, l10n.sellerProductImageRemoved);
      return;
    }
    final photo = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(hint: l10n.sellerProductImageHint),
      ),
    );
    if (photo == null || !mounted) return;
    _createCubit.attachImage(photo);
    AppFeedback.showSnackBar(context, l10n.sellerProductImageAttached);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider.value(
      value: _createCubit,
      child: BlocBuilder<SellerCreateProductCubit, SellerCreateProductState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: Text(
                _editing
                    ? l10n.sellerProductEditTitle
                    : l10n.sellerProductCreateTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SellerProductImagePickerCard(
                  selected: state.imageSelected,
                  onTap: _pickImage,
                ),
                const SizedBox(height: 24),
                SellerCreateProductFields(
                  name: _name,
                  price: _price,
                  description: _desc,
                  tags: _tags,
                  category: state.category,
                  onCategoryChanged: _createCubit.setCategory,
                  onRequiredChanged: (_) => setState(() {}),
                ),
                if (_editing) ...[
                  const SizedBox(height: 16),
                  SellerShopTextField(
                    controller: _changeReason,
                    label: l10n.changeReasonLabel,
                    icon: Icons.edit_note,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.changeReasonExplainer,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.palette.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                SellerCreateProductSubmitButton(
                  canSave: _canSave && !state.saving,
                  loading: state.saving,
                  onSave: _save,
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    try {
      await _createCubit.save(
        name: _name.text,
        description: _desc.text,
        price: _price.text,
        tags: _tags.text,
        l10n: l10n,
        changeReason: _changeReason.text.trim(),
      );
    } catch (_) {
      // This screen used to report success whatever happened and pop, so a
      // product that never reached the server looked saved.
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.sellerProductSaveFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    if (!mounted) return;
    AppFeedback.showSnackBar(
      context,
      _createCubit.state.imageFailed
          ? l10n.sellerProductImageUploadFailed
          : l10n.sellerProductSaved,
      icon: _createCubit.state.imageFailed
          ? Icons.error_outline
          : Icons.check_circle_rounded,
    );
    Navigator.pop(context);
  }
}
