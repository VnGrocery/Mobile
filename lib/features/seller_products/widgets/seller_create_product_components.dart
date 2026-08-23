import 'package:flutter/material.dart';

import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductImagePickerCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const SellerProductImagePickerCard({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.sellerProductImageTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: selected ? palette.positiveBg : palette.mutedSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? Icons.check_circle : Icons.add_photo_alternate,
                  size: 48,
                  color: selected ? AppColors.primaryGreen : context.palette.textSecondary,
                ),
                Text(
                  selected
                      ? l10n.sellerProductImageReady
                      : l10n.sellerProductImageSelect,
                  style: TextStyle(
                    color: selected ? AppColors.primaryGreen : context.palette.textSecondary,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SellerCreateProductFields extends StatelessWidget {
  final TextEditingController name;
  final TextEditingController price;
  final TextEditingController description;
  final TextEditingController tags;
  final String category;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onRequiredChanged;

  const SellerCreateProductFields({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.tags,
    required this.category,
    required this.onCategoryChanged,
    required this.onRequiredChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        TextField(
          controller: name,
          onChanged: onRequiredChanged,
          decoration: InputDecoration(labelText: l10n.sellerProductNameLabel),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: price,
          keyboardType: TextInputType.number,
          onChanged: onRequiredChanged,
          decoration: InputDecoration(labelText: l10n.sellerProductPriceLabel),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.sellerProductCategoryLabel,
              style: TextStyle(fontSize: 14, color: context.palette.textSecondary),
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: category,
          decoration: const InputDecoration(),
          items: CategoryPresenter.selectable
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(CategoryPresenter.label(l10n, category)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) onCategoryChanged(value);
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: description,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: l10n.sellerProductDescriptionLabel,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: tags,
          decoration: InputDecoration(
            labelText: l10n.sellerProductTagsLabel,
            hintText: l10n.sellerProductTagsHint,
          ),
        ),
      ],
    );
  }
}

class SellerCreateProductSubmitButton extends StatelessWidget {
  final bool canSave;
  final bool loading;
  final VoidCallback onSave;

  const SellerCreateProductSubmitButton({
    super.key,
    required this.canSave,
    required this.loading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: canSave ? onSave : null,
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                l10n.sellerProductSave,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
