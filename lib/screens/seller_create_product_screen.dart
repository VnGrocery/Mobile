import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
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
  String _category = 'Thịt bò';
  bool _loading = false;
  bool _imageSelected = false;

  static const _categories = [
    'Thịt bò',
    'Thịt lợn',
    'Thịt gà',
    'Hải sản',
    'Gia cầm',
    'Khác',
  ];

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _desc.dispose();
    _tags.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _name.text.trim().isNotEmpty &&
      _price.text.trim().isNotEmpty &&
      !_loading;

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final data = AppDataHooks.instance;
    data.addProduct(
      Product(
        id: data.nextId(),
        shopId: widget.shopId,
        name: _name.text.trim(),
        description: _desc.text.trim(),
        category: _category,
        freshnessScore: 80,
        freshnessNote: _imageSelected
            ? 'Sản phẩm mới tạo, đã có ảnh demo.'
            : 'Sản phẩm mới tạo.',
        price: int.tryParse(_price.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        tags: _tags.text
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList(),
        status: 'Draft',
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu sản phẩm nháp')),
    );
    Navigator.pop(context);
  }

  void _toggleImage() {
    setState(() => _imageSelected = !_imageSelected);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _imageSelected ? 'Đã chọn ảnh sản phẩm demo' : 'Đã bỏ ảnh sản phẩm',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text(
          'Thêm sản phẩm mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Hình ảnh sản phẩm',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _toggleImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color:
                    _imageSelected ? palette.positiveBg : palette.mutedSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _imageSelected
                        ? Icons.check_circle
                        : Icons.add_photo_alternate,
                    size: 48,
                    color:
                        _imageSelected ? AppColors.primaryGreen : Colors.grey,
                  ),
                  Text(
                    _imageSelected
                        ? 'Ảnh demo đã sẵn sàng'
                        : 'Nhấn để chọn ảnh demo',
                    style: TextStyle(
                      color:
                          _imageSelected ? AppColors.primaryGreen : Colors.grey,
                      fontSize: 14,
                      fontWeight:
                          _imageSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration:
                const InputDecoration(labelText: 'Giá niêm yết (VNĐ/kg)'),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 4),
            child: Text(
              'Danh mục',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(),
            items: _categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) =>
                setState(() => _category = value ?? _category),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _desc,
            maxLines: 4,
            decoration: const InputDecoration(labelText: 'Mô tả sản phẩm'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tags,
            decoration: const InputDecoration(
              labelText: 'Tags (cách nhau bằng dấu phẩy)',
              hintText: 'VD: Tươi sống, Nhập khẩu, Ít béo',
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _canSave ? _save : null,
              child: _loading
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
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
