import 'package:flutter/material.dart';

import '../data/data_hooks.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';

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

  static const _categories = [
    'Thịt bò',
    'Thịt lợn',
    'Thịt gà',
    'Hải sản',
    'Thịt gia cầm khác',
    'Thịt thú rừng',
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
      _name.text.trim().isNotEmpty && _price.text.trim().isNotEmpty && !_loading;

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final data = AppDataHooks.instance;
    data.addProduct(Product(
      id: data.nextId(),
      shopId: widget.shopId,
      name: _name.text.trim(),
      description: _desc.text.trim(),
      category: _category,
      freshnessScore: 80,
      freshnessNote: 'Sản phẩm mới tạo.',
      price: int.tryParse(_price.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      tags: _tags.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      status: 'Draft',
    ));
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thêm sản phẩm mới',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Hình ảnh sản phẩm',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tính năng đang được phát triển')),
            ),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD3D3D3)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate,
                      size: 48, color: Colors.grey),
                  Text('Nhấn để tải ảnh lên',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
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
            child: Text('Danh mục',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
          ),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
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
              labelText: 'Tags (Cách nhau bằng dấu phẩy)',
              hintText: 'VD: Tươi sống, Nhập khẩu, Diet',
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
                          color: Colors.white, strokeWidth: 2.5))
                  : const Text('Lưu sản phẩm',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
