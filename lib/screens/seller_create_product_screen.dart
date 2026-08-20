import 'dart:typed_data';
import 'package:vngrocery/screens/camera_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_cubit.dart';
import 'package:vngrocery/features/seller_products/controllers/seller_create_product_state.dart';
import 'package:vngrocery/features/seller_products/widgets/seller_create_product_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerCreateProductScreen extends StatefulWidget {
  final String shopId;

  const SellerCreateProductScreen({super.key, required this.shopId});

  @override
  State<SellerCreateProductScreen> createState() =>
      _SellerCreateProductScreenState();
}

class _SellerCreateProductScreenState extends State<SellerCreateProductScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();
  final _tags = TextEditingController();
  late final SellerCreateProductCubit _createCubit;

  bool get _canSave =>
      _name.text.trim().isNotEmpty && _price.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _createCubit = SellerCreateProductCubit(shopId: widget.shopId);
  }

  @override
  void dispose() {
    _createCubit.close();
    _name.dispose();
    _price.dispose();
    _desc.dispose();
    _tags.dispose();
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
                l10n.sellerProductCreateTitle,
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
    await _createCubit.save(
      name: _name.text,
      description: _desc.text,
      price: _price.text,
      tags: _tags.text,
      l10n: l10n,
    );
    if (!mounted) return;
    AppFeedback.showSnackBar(context, l10n.sellerProductSavedDraft);
    Navigator.pop(context);
  }
}
