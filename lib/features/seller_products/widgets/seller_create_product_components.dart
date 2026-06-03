import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';

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
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hình ảnh sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  color: selected ? AppColors.primaryGreen : Colors.grey,
                ),
                Text(
                  selected ? 'Ảnh demo đã sẵn sàng' : 'Nhấn để chọn ảnh demo',
                  style: TextStyle(
                    color: selected ? AppColors.primaryGreen : Colors.grey,
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
    return Column(
      children: [
        TextField(
          controller: name,
          onChanged: onRequiredChanged,
          decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: price,
          keyboardType: TextInputType.number,
          onChanged: onRequiredChanged,
          decoration: const InputDecoration(labelText: 'Giá niêm yết (VNĐ/kg)'),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Danh mục',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          initialValue: category,
          decoration: const InputDecoration(),
          items: SellerProductPresenter.categories
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
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
          decoration: const InputDecoration(labelText: 'Mô tả sản phẩm'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: tags,
          decoration: const InputDecoration(
            labelText: 'Tags (cách nhau bằng dấu phẩy)',
            hintText: 'VD: Tươi sống, Nhập khẩu, Ít béo',
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
            : const Text(
                'Lưu sản phẩm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
