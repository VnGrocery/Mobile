import 'package:flutter/material.dart';

import '../core/ui/app_feedback.dart';
import '../features/seller_products/seller_product_presenter.dart';
import '../features/seller_products/widgets/seller_create_product_components.dart';
import '../theme/app_palette.dart';

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
  String _category = SellerProductPresenter.categories.first;
  bool _loading = false;
  bool _imageSelected = false;

  bool get _canSave =>
      _name.text.trim().isNotEmpty &&
      _price.text.trim().isNotEmpty &&
      !_loading;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _desc.dispose();
    _tags.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: const Text(
          'Thêm sản phẩm mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SellerProductImagePickerCard(
            selected: _imageSelected,
            onTap: _toggleImage,
          ),
          const SizedBox(height: 24),
          SellerCreateProductFields(
            name: _name,
            price: _price,
            description: _desc,
            tags: _tags,
            category: _category,
            onCategoryChanged: (category) =>
                setState(() => _category = category),
            onRequiredChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 32),
          SellerCreateProductSubmitButton(
            canSave: _canSave,
            loading: _loading,
            onSave: _save,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    SellerProductPresenter.addProduct(
      shopId: widget.shopId,
      name: _name.text,
      description: _desc.text,
      category: _category,
      hasImage: _imageSelected,
      price: _price.text,
      tags: _tags.text,
    );
    if (!mounted) return;
    AppFeedback.showSnackBar(context, 'Đã lưu sản phẩm nháp');
    Navigator.pop(context);
  }

  void _toggleImage() {
    setState(() => _imageSelected = !_imageSelected);
    AppFeedback.showSnackBar(
      context,
      _imageSelected ? 'Đã chọn ảnh sản phẩm demo' : 'Đã bỏ ảnh sản phẩm',
    );
  }
}
